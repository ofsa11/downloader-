<script setup>
import { RouterView } from "vue-router";
import { NMessageProvider, NConfigProvider, NDialogProvider } from "naive-ui";
</script>

<template>
  <n-config-provider>
    <n-message-provider>
      <n-dialog-provider>
        <RouterView />
      </n-dialog-provider>
    </n-message-provider>
  </n-config-provider>
</template>
