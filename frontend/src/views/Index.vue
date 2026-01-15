<template>
  <div>
    <div class="hero min-h-screen bg-gray-50">
      <div class="hero-content text-center">
        <div class="max-w-xl w-full">
          <h1 class="text-5xl font-bold mb-8 text-gray-800">WR 下载器</h1>
          
          <div class="bg-white p-8 rounded-xl shadow-lg mb-8">
            <p class="text-lg text-gray-600 mb-6 leading-relaxed">
              本工具将 WR 中的图书下载到本地。
              <br />
              利用移动端的缓存功能，解密缓存文件。
              <br />
              <span class="text-sm text-gray-400">前提：需要在 WR 中能够正常完整阅读</span>
            </p>
            
            <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
              <p class="text-red-600 font-bold text-lg flex items-center justify-center">
                <span class="mr-2 text-2xl">⚠️</span> 
                警告：使用本软件有极大导致封号的风险！
              </p>
              <p class="text-red-500 text-sm mt-2">请仅使用小号测试，后果自负。</p>
            </div>

            <div class="flex justify-center gap-4">
              <n-button
                strong
                type="info"
                size="large"
                class="px-8"
                @click="showModalRef = true"
              >
                扫码登录
              </n-button>
              
              <n-button
                strong
                secondary
                type="primary"
                size="large"
                class="px-8"
                @click="openGithub"
              >
                <template #icon>
                  <n-icon>
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                      <path d="M256 32C132.3 32 32 134.9 32 261.7c0 101.5 64.2 187.5 153.2 217.9a17.56 17.56 0 0 0 3.8.4c8.3 0 11.5-6.1 11.5-11.4c0-5.5-.2-19.9-.3-39.1a102.4 102.4 0 0 1-22.6 2.7c-43.1 0-52.9-33.5-52.9-33.5c-10.2-26.5-24.9-33.6-24.9-33.6c-19.5-13.7-.1-14.1 1.4-14.1h.1c22.5 2 34.3 23.8 34.3 23.8c11.2 19.6 26.2 25.1 39.6 25.1a63 63 0 0 0 25.6-6c2-14.8 7.8-24.9 14.2-30.7c-49.7-5.8-102-25.5-102-113.5c0-25.1 8.7-45.6 23-61.6c-2.3-5.8-10-29.2 2.2-60.8a18.64 18.64 0 0 1 5-.5c8.1 0 26.4 3.1 56.6 24.1a208.21 208.21 0 0 1 112.2 0c30.2-21 48.5-24.1 56.6-24.1a18.64 18.64 0 0 1 5 .5c12.2 31.6 4.5 55 2.2 60.8c14.3 16.1 23 36.6 23 61.6c0 88.2-52.4 107.6-102.3 113.3c8 7.1 15.2 21.1 15.2 42.5c0 30.7-.3 55.5-.3 63c0 5.4 3.1 11.5 11.4 11.5a19.35 19.35 0 0 0 4-.4C415.9 449.2 480 363.1 480 261.7C480 134.9 379.7 32 256 32z" fill="currentColor"></path>
                    </svg>
                  </n-icon>
                </template>
                GitHub
              </n-button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div>
      <n-modal
        v-model:show="showModalRef"
        :mask-closable="false"
        preset="dialog"
        type="info"
        title="扫码登陆"
      >
        <h3>请点击获取登录二维码，使用 WR 扫码登录。</h3>
        <canvas id="loginQrcode"></canvas>
        <n-button class="ml-70" @click="gerLoginQrcode"
          >获取登录二维码</n-button
        >
      </n-modal>
    </div>
  </div>
</template>

<script setup>
import QRcode from "qrcode";
import { ref, onBeforeMount } from "vue";
import { NButton, NModal } from "naive-ui";
import { GetLoginUid, ConfirmLogin } from "../../wailsjs/go/main/App";
import { useRouter } from "vue-router";

const router = useRouter();
const showModalRef = ref(false);
const qrUid = ref("");
//检查登录状态
const checkLoginStatus = () => {
  if (localStorage.getItem("userInfo")) {
    router.push("/home");
  }
};
//GitHub
const openGithub = () => {
  window.open("https://github.com/HuanMeng233");
};
//获取登录二维码
const gerLoginQrcode = () => {
  GetLoginUid().then((res) => {
    qrUid.value = res;
    console.log(qrUid.value);
    showQrcode(qrUid.value);
  });
};
//登录
const Login = () => {
  ConfirmLogin(qrUid.value).then((res) => {
    if (res) {
      console.log("登录成功");
      console.log(res);
      localStorage.setItem("userInfo", res);
      router.push("/home");
    }
  });
};
//显示二维码并登录
const showQrcode = (qrUid) => {
  let loginUrl = "https://weread.qq.com/web/confirm?pf=2&uid=" + qrUid;
  let loginQrcode = document.getElementById("loginQrcode");
  QRcode.toCanvas(loginQrcode, loginUrl, function (error) {
    if (error) console.error(error);
  });
  Login();
};
onBeforeMount(() => {
  checkLoginStatus();
});
</script>

<style scoped>
.hero {
  display: grid;
  width: 100%;
  place-items: center;
  background-size: cover;
  background-position: center;
}

.hero > * {
  grid-column-start: 1;
  grid-row-start: 1;
}

.hero-content {
  z-index: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  max-width: 80rem;
  gap: 1rem;
  padding: 1rem;
}
</style>
