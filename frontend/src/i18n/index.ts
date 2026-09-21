import type { AppLocale } from '@/constants/i18n';
import type { MessageSchema } from '@/constants/i18n';
import enUS from './en-US';
import zhTW from './zh-TW';

// For linting only.
export default {
  'en-US': enUS,
  'zh-TW': zhTW,
} as Record<AppLocale, MessageSchema>;
