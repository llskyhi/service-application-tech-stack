import { defineBoot } from '#q-app';

import type { AppLocale, MessageSchema } from '@/constants/i18n';
import { i18nService } from '@/service/i18n';

// See https://vue-i18n.intlify.dev/guide/advanced/typescript.html#global-resource-schema-type-definition
/* eslint-disable @typescript-eslint/no-empty-object-type */
declare module 'vue-i18n' {
  // define the locale messages schema
  export interface DefineLocaleMessage extends MessageSchema {}

  // define the datetime format schema
  export interface DefineDateTimeFormat {}

  // define the number format schema
  export interface DefineNumberFormat {}
}
/* eslint-enable @typescript-eslint/no-empty-object-type */

export default defineBoot(async ({ app }) => {
  app.use(i18nService.i18n);
  const initialLocale: AppLocale = i18nService.resolveInitialLocale();
  await i18nService.setLocale(initialLocale);
});
