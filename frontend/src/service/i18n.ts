import type { QuasarLanguage } from 'quasar';
import { computed, ref } from 'vue';
import { createI18n } from 'vue-i18n';
import { Lang } from 'quasar';

import type { AppLocale, MessageSchema } from '@/constants/i18n';
import { FALLBACK_LOCALE, FALLBACK_MESSAGES, SUPPORTED_LOCALES } from '@/constants/i18n';

const LOCALE_STORAGE_KEY = 'app.locale';

const quasarLanguagePackLoaders = (() => {
  // NOTE: cannot use Node.js module 'path' in client code
  function toStem(posixFilePath: string): string {
    return posixFilePath
      .split('/') // POSIX file separator
      .pop()!
      .replace(/\.[^./]+$/, '');
  }

  const rawQuasarLanguagePackLoaders = import.meta.glob(
    '../../node_modules/quasar/lang/*',
  ) as Record<string, () => Promise<{ default: QuasarLanguage }>>;

  return Object.fromEntries(
    Object.entries(rawQuasarLanguagePackLoaders).map(([filePath, rawQuasarLanguagePackLoader]) => [
      toStem(filePath),
      () =>
        rawQuasarLanguagePackLoader()
          .then((module) => module.default)
          .catch((reason) => {
            console.error(reason);
            return undefined;
          }),
    ]),
  );
})();

const appMessageLoaders: Record<AppLocale, () => Promise<MessageSchema>> = {
  'en-US': async () => (await import('@/i18n/en-US')).default,
  'zh-TW': async () => (await import('@/i18n/zh-TW')).default,
} as const;

/**
 * I18n instance ONLY for boot file usage.
 */
const i18n = createI18n<{ message: MessageSchema }, AppLocale, false>({
  legacy: false,
  fallbackLocale: FALLBACK_LOCALE,
});
i18n.global.setLocaleMessage(FALLBACK_LOCALE, FALLBACK_MESSAGES);

const currentLocale = computed<AppLocale>(() => {
  return i18n.global.locale.value;
});

function isSupportedLocale(locale: string): locale is AppLocale {
  return (SUPPORTED_LOCALES as readonly string[]).includes(locale);
}

/**
 * Switch i18n locale.
 */
async function setLocale(locale: AppLocale): Promise<void> {
  console.log(`Switching to locale: ${locale}.`);

  const quasarLanguagePack = await loadQuasarLanguagePack(locale);
  if (quasarLanguagePack === undefined) {
    console.warn(`Failed to load Quasar language pack for locale: ${locale}.`);
  } else {
    // TODO: fix the type error here
    Lang.set(quasarLanguagePack);
  }

  const appMessages = await loadAppMessages(locale);
  if (appMessages === undefined) {
    console.warn(`Failed to load i18n messages for locale: ${locale}.`);
  } else {
    i18n.global.setLocaleMessage(locale, appMessages);
  }

  i18n.global.locale.value = locale;
  document.documentElement.setAttribute('lang', locale);
  localStorage.setItem(LOCALE_STORAGE_KEY, locale);
}

async function loadQuasarLanguagePack(locale: AppLocale): Promise<QuasarLanguage | undefined> {
  // TODO: exception handling
  return await quasarLanguagePackLoaders[locale]?.();
}

async function loadAppMessages(locale: AppLocale): Promise<MessageSchema | undefined> {
  // TODO: exception handling
  return await appMessageLoaders[locale]?.();
}

function resolveInitialLocale(): AppLocale {
  const storedLocale = localStorage.getItem(LOCALE_STORAGE_KEY);
  if (storedLocale !== null && isSupportedLocale(storedLocale)) {
    return storedLocale;
  }

  const browserLocale = Lang.getLocale();
  if (browserLocale !== undefined && isSupportedLocale(browserLocale)) {
    return browserLocale;
  }

  return FALLBACK_LOCALE;
}

const supportedLocaleNames = ref<Record<AppLocale, string>>({} as Record<AppLocale, string>);
const computedSupportedLocaleNames = computed(() => supportedLocaleNames.value);

async function buildLocaleNativeNames(locales: readonly string[]): Promise<Record<string, string>> {
  const entries = await Promise.all(
    locales.map(async (locale) => {
      const quasarLanguagePack = await quasarLanguagePackLoaders[locale]?.();
      return [locale, quasarLanguagePack?.nativeName ?? locale];
    }),
  );

  return Object.fromEntries(entries);
}
void buildLocaleNativeNames(SUPPORTED_LOCALES).then(
  (result) => (supportedLocaleNames.value = result),
);

export const i18nService = {
  i18n,
  currentLocale,
  supportedLocaleNames: computedSupportedLocaleNames,
  isSupportedLocale,
  setLocale,
  resolveInitialLocale,
};
