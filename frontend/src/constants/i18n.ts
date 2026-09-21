import fallbackMessages from '@/i18n/en-US';

export const SUPPORTED_LOCALES = ['en-US', 'zh-TW'] as const;
export type AppLocale = (typeof SUPPORTED_LOCALES)[number];
export const FALLBACK_LOCALE: AppLocale = 'en-US';
export type MessageSchema = typeof fallbackMessages;
export const FALLBACK_MESSAGES = fallbackMessages;
