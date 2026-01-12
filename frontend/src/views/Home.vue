<template>
  <div class="min-w-[800px] flex flex-col min-h-screen">
    <div class="flex-grow">
      <h2 class="text-center items-center">
        <n-button @click="clearCache" size="large">清除账号信息</n-button>
        <n-button
          strong
          secondary
          type="primary"
          class="ml-4"
          size="large"
          @click="openGithub"
        >
          GitHub

          <n-icon size="20">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              viewBox="0 0 512 512"
            >
              <path
                d="M256 32C132.3 32 32 134.9 32 261.7c0 101.5 64.2 187.5 153.2 217.9a17.56 17.56 0 0 0 3.8.4c8.3 0 11.5-6.1 11.5-11.4c0-5.5-.2-19.9-.3-39.1a102.4 102.4 0 0 1-22.6 2.7c-43.1 0-52.9-33.5-52.9-33.5c-10.2-26.5-24.9-33.6-24.9-33.6c-19.5-13.7-.1-14.1 1.4-14.1h.1c22.5 2 34.3 23.8 34.3 23.8c11.2 19.6 26.2 25.1 39.6 25.1a63 63 0 0 0 25.6-6c2-14.8 7.8-24.9 14.2-30.7c-49.7-5.8-102-25.5-102-113.5c0-25.1 8.7-45.6 23-61.6c-2.3-5.8-10-29.2 2.2-60.8a18.64 18.64 0 0 1 5-.5c8.1 0 26.4 3.1 56.6 24.1a208.21 208.21 0 0 1 112.2 0c30.2-21 48.5-24.1 56.6-24.1a18.64 18.64 0 0 1 5 .5c12.2 31.6 4.5 55 2.2 60.8c14.3 16.1 23 36.6 23 61.6c0 88.2-52.4 107.6-102.3 113.3c8 7.1 15.2 21.1 15.2 42.5c0 30.7-.3 55.5-.3 63c0 5.4 3.1 11.5 11.4 11.5a19.35 19.35 0 0 0 4-.4C415.9 449.2 480 363.1 480 261.7C480 134.9 379.7 32 256 32z"
                fill="currentColor"
              ></path>
            </svg>
          </n-icon>
        </n-button>
        <n-button
          strong
          type="primary"
          class="ml-4"
          size="large"
          @click="refreshBookShelf"
          :disabled="isBookShelfLoading"
        >
          {{ isBookShelfLoading ? '刷新中...' : '刷新书架' }}
        </n-button>
        <n-button
          strong
          type="primary"
          class="ml-4"
          size="large"
          @click="downloadAllBooks"
          :disabled="isDownloadingAll"
        >
          {{ isDownloadingAll ? '正在下载...' : '一键下载所有书籍' }}
        </n-button>
        <div v-if="isDownloadingAll" class="mt-2 text-sm text-green-600">
          正在下载: {{ currentDownloadingBook }} ({{ downloadedCount }}/{{ totalBooks }})
        </div>
        <div v-if="isBookShelfLoading" class="mt-2 text-sm text-blue-600">
          正在加载书架数据，请稍候...
        </div>
      </h2>
      <div class="p-[10px]">
        <n-grid x-gap="5" y-gap="5" :cols="3">
          <n-gi v-for="book in bookList" :key="book.bookId">
            <n-card
              hoverable
              class="w-full max-w-[300px] mx-auto"
              @click="
                downloadBook(
                  book.bookId,
                  book.title,
                  book.format == 'txt' ? true : false
                )
              "
            >
              <div class="cover">
                <img class="coverimg" :src="book.cover" />
              </div>
              <div class="info">
                <div class="title">{{ book.title }}</div>
                <div class="author">{{ book.author }}</div>
              </div>
            </n-card>
          </n-gi>
        </n-grid>
      </div>
      <div>
        <n-modal
          v-model:show="shwoDownloadModalRef"
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
    </div>
    <!-- 底部白色底栏 -->
    <div class="bg-white border-t p-2 text-center text-sm text-gray-600">
      文件夹中的书籍只能获取前四本，程序默认从第九本开始下载，一次最多下载 47 本
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
} from "naive-ui";
import { onBeforeMount, ref } from "vue";
import { GetBookShelf, Download } from "../../wailsjs/go/main/App.js";
import { useRouter } from "vue-router";
const bookList = ref([]);
const vidRef = ref(0);
const skeyRef = ref("");
const shwoDownloadModalRef = ref(false);
const downloadBookId = ref("");
const downloadBookName = ref("");
const downloadBookType = ref("");
const message = useMessage();
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
  localStorage.clear();
  router.push("/");
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
  shwoDownloadModalRef.value = true;
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
});
</script>
<style scoped>
.n-card {
  border-radius: 10px;
  height: 150px;
  width: 100%;
  max-width: 300px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  .cover {
    width: 70px;
    height: 100px;
    display: table-cell;
    text-align: left;
    vertical-align: middle;
    .coverimg {
      width: 70px;
      height: 100px;
      vertical-align: top;
      object-fit: cover;
    }
  }
  .info {
    padding: 0 0 0 24px;
    display: table-cell;
    vertical-align: middle;
    .title {
      font-size: 14px;
      font-weight: 500;
      line-height: 1.4;
      margin-bottom: 5px;
      text-align: center;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      word-break: break-word;
    }
    .author {
      margin-top: 5px;
      font-size: 14px;
      line-height: 1.5;
      text-align: center;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}
</style>
