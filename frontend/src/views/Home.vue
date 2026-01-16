<template>
  <div class="flex flex-col min-h-screen bg-gray-50">
    <!-- 顶部工具栏 -->
    <div class="bg-white shadow-sm p-4 sticky top-0 z-10">
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="flex items-center gap-4">
          <n-button @click="clearCache" type="error" ghost size="medium">
            <template #icon>
              <n-icon>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M448 256c0-106-86-192-192-192S64 150 64 256s86 192 192 192 192-86 192-192z" fill="none" stroke="currentColor" stroke-miterlimit="10" stroke-width="32"/><path d="M250.26 166.05L256 288l5.73-121.95a5.74 5.74 0 00-5.79-6h0a5.74 5.74 0 00-5.68 6z" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="32"/><path d="M256 367.91a20 20 0 1120-20 20 20 0 01-20 20z" fill="currentColor"/></svg>
              </n-icon>
            </template>
            清除账号
          </n-button>
        </div>

        <div class="flex items-center text-xs text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
           <n-icon class="mr-1 text-gray-400" size="14">
             <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M256 56C145.72 56 56 145.72 56 256s89.72 200 200 200 200-89.72 200-200S366.28 56 256 56zm0 82a26 26 0 1 1-26 26 26 26 0 0 1 26-26zm48 226h-88a16 16 0 0 1 0-32h28v-88h-16a16 16 0 0 1 0-32h32a16 16 0 0 1 16 16v104h28a16 16 0 0 1 0 32z" fill="currentColor"/></svg>
           </n-icon>
           文件夹中的书籍只能获取前四本，程序默认从第九本开始下载，一次最多下载 47 本
         </div>

        <div class="flex items-center gap-4">
           <!-- 状态提示 -->
          <div v-if="isDownloadingAll" class="text-sm text-green-600 bg-green-50 px-3 py-1 rounded-full animate-pulse">
            正在下载: {{ currentDownloadingBook }} ({{ downloadedCount }}/{{ totalBooks }})
          </div>
          <div v-else-if="isBookShelfLoading" class="text-sm text-blue-600 bg-blue-50 px-3 py-1 rounded-full">
            正在加载书架...
          </div>

          <n-button
            secondary
            type="primary"
            @click="refreshBookShelf"
            :disabled="isBookShelfLoading"
          >
            <template #icon>
              <n-icon><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M320 146s24.36-12-64-12a160 160 0 10160 160" fill="none" stroke="currentColor" stroke-linecap="round" stroke-miterlimit="10" stroke-width="32"/><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="32" d="M256 58l80 80-80 80"/></svg></n-icon>
            </template>
            刷新书架
          </n-button>
          
          <n-button
            type="primary"
            @click="downloadAllBooks"
            :disabled="isDownloadingAll"
          >
            <template #icon>
              <n-icon><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M336 176h40a40 40 0 0140 40v208a40 40 0 01-40 40H136a40 40 0 01-40-40V216a40 40 0 0140-40h40" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="32"/><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="32" d="M176 272l80 80 80-80M256 48v288"/></svg></n-icon>
            </template>
            一键下载全部
          </n-button>

          <n-button
            secondary
            circle
            @click="openGithub"
            title="GitHub"
          >
            <template #icon>
              <n-icon>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M256 32C132.3 32 32 134.9 32 261.7c0 101.5 64.2 187.5 153.2 217.9a17.56 17.56 0 0 0 3.8.4c8.3 0 11.5-6.1 11.5-11.4c0-5.5-.2-19.9-.3-39.1a102.4 102.4 0 0 1-22.6 2.7c-43.1 0-52.9-33.5-52.9-33.5c-10.2-26.5-24.9-33.6-24.9-33.6c-19.5-13.7-.1-14.1 1.4-14.1h.1c22.5 2 34.3 23.8 34.3 23.8c11.2 19.6 26.2 25.1 39.6 25.1a63 63 0 0 0 25.6-6c2-14.8 7.8-24.9 14.2-30.7c-49.7-5.8-102-25.5-102-113.5c0-25.1 8.7-45.6 23-61.6c-2.3-5.8-10-29.2 2.2-60.8a18.64 18.64 0 0 1 5-.5c8.1 0 26.4 3.1 56.6 24.1a208.21 208.21 0 0 1 112.2 0c30.2-21 48.5-24.1 56.6-24.1a18.64 18.64 0 0 1 5 .5c12.2 31.6 4.5 55 2.2 60.8c14.3 16.1 23 36.6 23 61.6c0 88.2-52.4 107.6-102.3 113.3c8 7.1 15.2 21.1 15.2 42.5c0 30.7-.3 55.5-.3 63c0 5.4 3.1 11.5 11.4 11.5a19.35 19.35 0 0 0 4-.4C415.9 449.2 480 363.1 480 261.7C480 134.9 379.7 32 256 32z" fill="currentColor"></path></svg>
              </n-icon>
            </template>
          </n-button>
        </div>
      </div>
    </div>

    <div class="flex-grow py-6 max-w-7xl mx-auto" style="width: 94%;">
        <n-grid x-gap="16" y-gap="16" cols="2 s:3 m:4 l:5 xl:6" responsive="screen">
          <n-gi v-for="book in bookList" :key="book.bookId">
            <n-card
              hoverable
              class="h-full transition-transform duration-300 hover:-translate-y-1 hover:shadow-lg cursor-pointer"
              content-style="padding: 6px;"
              @click="
                downloadBook(
                  book.bookId,
                  book.title,
                  book.format == 'txt' ? true : false
                )
              "
            >
              <div class="flex flex-col h-full">
                <div class="relative w-full aspect-[2/3] mb-3 overflow-hidden rounded bg-gray-100">
                   <img class="w-full h-full object-cover transition-transform duration-500 hover:scale-110" :src="book.cover" loading="lazy" />
                </div>
                <div class="flex-grow flex flex-col justify-between">
                  <div class="text-sm font-bold text-gray-800 line-clamp-2 mb-1" :title="book.title">{{ book.title }}</div>
                  <div class="text-xs text-gray-500 truncate">{{ book.author }}</div>
                </div>
              </div>
            </n-card>
          </n-gi>
        </n-grid>
    </div>
    
    <!-- 模态框区域 -->
    <div>
        <n-modal
          v-model:show="showDownloadModalRef"
          :mask-closable="false"
          preset="dialog"
          type="success"
          size="huge"
          :title="downloadBookName"
        >
          <n-button type="primary" class="ml-70" @click="downloadBookStart"
            >下载当前书籍</n-button
          >
        </n-modal>
      </div>
      <div>
        <n-modal
          v-model:show="showRiskModal"
          :mask-closable="false"
          preset="dialog"
          type="error"
          title="⚠️ 封号风险警告"
          positive-text="我知道了，后果自负"
          @positive-click="showRiskModal = false"
        >
          <div class="text-lg font-bold text-red-600">
            <p class="mb-4">郑重警告：</p>
            <p class="mb-4">使用本软件进行下载操作有极大导致 WR 账号被封禁的风险！</p>
            <p class="mb-4">一旦封号，将无法解封，请务必谨慎使用！</p>
            <p>建议仅使用小号进行测试。</p>
          </div>
        </n-modal>
  </div>

  </div>
</template>

<script setup>
import {
  NButton,
  NIcon,
  useMessage,
  NModal,
  NGrid,
  NGi,
  NCard,
  NAvatar,
  useDialog,
} from "naive-ui";
import { onBeforeMount, ref } from "vue";
import { GetBookShelf, Download, GetUserInfo } from "../../wailsjs/go/main/App.js";
import { useRouter } from "vue-router";
const bookList = ref([]);
const vidRef = ref(0);
const skeyRef = ref("");
const showDownloadModalRef = ref(false);
const showRiskModal = ref(false);
const downloadBookId = ref("");
const downloadBookName = ref("");
const downloadBookType = ref("");
const message = useMessage();
const dialog = useDialog();
const router = useRouter();

// 书架加载状态
const isBookShelfLoading = ref(false);

// 一键下载相关状态
const isDownloadingAll = ref(false);
const currentDownloadingBook = ref("");
const downloadedCount = ref(0);
const totalBooks = ref(0);
const checkLoginStatus = () => {
  if (!localStorage.getItem("userInfo")) {
    localStorage.clear();
    router.push("/");
  }
};
const openGithub = () => {
  window.open("https://github.com/HuanMeng233");
};
const getBookShelf = async (vid, skey) => {
  isBookShelfLoading.value = true;
  try {
    const res = await GetBookShelf(vid.toString(), skey);
    localStorage.setItem("bookShelf", res);
    bookList.value = JSON.parse(res);
  } finally {
    isBookShelfLoading.value = false;
  }
};
const clearCache = () => {
  dialog.warning({
    title: "警告",
    content: "确定要清除账号信息并退出登录吗？",
    positiveText: "确定",
    negativeText: "取消",
    onPositiveClick: () => {
      localStorage.clear();
      router.push("/");
    },
  });
};

// 刷新书架数据
const refreshBookShelf = async () => {
  let userInfo = JSON.parse(localStorage.getItem("userInfo"));
  if (userInfo) {
    await getBookShelf(userInfo.vid, userInfo.skey);
    message.success("书架数据已刷新");
  }
};
const downloadBook = (bookId, bookName, isTxt) => {
  showDownloadModalRef.value = true;
  downloadBookId.value = bookId.toString();
  downloadBookName.value = bookName;
  //bookIsTxt.value = isTxt;
};
const downloadBookStart = () => {
  let vid = vidRef.value.toString();

  Download(downloadBookId.value, skeyRef.value, vid).then((msg) => {
    if (msg == "下载完成") {
      message.success(
        "下载完成,请到文件夹查看，可手动打开“看这里”文件夹下的xhtml 用浏览器导出pdf"
      );
    } else {
      message.error(msg);
    }
  });
};

// 生成2-5秒的随机延迟
const randomDelay = () => {
  const delay = Math.floor(Math.random() * (5000 - 2000 + 1)) + 2000;
  return new Promise(resolve => setTimeout(resolve, delay));
};

// 一键下载所有书籍（从第九本书开始）
const downloadAllBooks = async () => {
  if (bookList.value.length === 0) {
    message.warning("书架为空，没有可下载的书籍");
    return;
  }

  // 从第九本书开始（索引8）
  const startIndex = 8;
  const booksToDownload = bookList.value.slice(startIndex);

  if (booksToDownload.length === 0) {
    message.warning("书架中没有足够的书籍，从第九本开始没有可下载的书籍");
    return;
  }

  isDownloadingAll.value = true;
  downloadedCount.value = 0;
  totalBooks.value = booksToDownload.length;

  try {
    let vid = vidRef.value.toString();

    for (const [index, book] of booksToDownload.entries()) {
      currentDownloadingBook.value = book.title;
      
      // 调用下载函数
      await Download(book.bookId, skeyRef.value, vid);
      
      downloadedCount.value++;
      
      // 如果不是最后一本书，添加随机延迟
      if (index < booksToDownload.length - 1) {
        const delaySeconds = (Math.floor(Math.random() * (5 - 2 + 1)) + 2);
        message.info(`等待 ${delaySeconds} 秒后下载下一本书...`);
        await randomDelay();
      }
    }

    message.success("所有书籍下载完成");
  } catch (error) {
    message.error(`下载过程中发生错误: ${error.message}`);
  } finally {
    isDownloadingAll.value = false;
    currentDownloadingBook.value = "";
  }
};

onBeforeMount(() => {
  checkLoginStatus();
  let userInfo = JSON.parse(localStorage.getItem("userInfo"));
  vidRef.value = userInfo.vid;
  skeyRef.value = userInfo.skey;
  // 每次进入页面都获取最新的书架数据
  getBookShelf(userInfo.vid, userInfo.skey);
  
  // 弹出风险警告
  showRiskModal.value = true;
});
</script>
<style scoped>
.n-card {
  border-radius: 6px;
  width: 100%;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</style>

<style>
/* 隐藏滚动条 */
::-webkit-scrollbar {
  display: none;
}
html, body {
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
}
</style>
