<template>
  <q-select
    :model-value="i18nService.currentLocale.value"
    :options="options"
    @update:model-value="setLocale"
    map-options
    emit-value
  >
    <template #prepend>
      <q-icon name="language" />
    </template>
  </q-select>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { QIcon, QSelect } from 'quasar';

import type { AppLocale } from '@/constants/i18n';
import { i18nService } from '@/service/i18n';

const options = computed(() => {
  return Object.entries(i18nService.supportedLocaleNames.value).map(([locale, name]) => ({
    value: locale,
    label: name,
  }));
});

async function setLocale(locale: AppLocale) {
  await i18nService.setLocale(locale);
}
</script>
