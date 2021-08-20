#include "playthread.h"

#include <SDL2/SDL.h>
#include <QDebug>
#include <QFile>

#define FILENAME "F:/in.pcm"
#define SAMPLE_RATE 44100
#define SAMPLE_SIZE 16
#define CHANNELS 2
// 音频缓冲区的样本数量
#define SAMPLES 1024
// 每个样本占用多少个字节
#define BYTES_PER_SAMPLE ((SAMPLE_SIZE * CHANNELS) / 8)
// 文件缓冲区的大小
#define BUFFER_SIZE (SAMPLES * BYTES_PER_SAMPLE)

PlayThread::PlayThread(QObject *parent) : QThread(parent) {
    connect(this, &PlayThread::finished,
            this, &PlayThread::deleteLater);

}

PlayThread::~PlayThread() {
    disconnect();
    requestInterruption();
    quit();
    wait();

    qDebug() << this << "析构了";
}

int bufferLen;
char *bufferData;

// 等待音频设备回调(会回调多次)
void pull_audio_data(void *userdata,
                     // 需要往stream中填充PCM数据
                     Uint8 *stream,
                     // 希望填充的大小(samples * format * channels / 8)
                     int len
                    ) {
    // 清空stream（静音处理）
    SDL_memset(stream, 0, len);

    // 文件数据还没准备好
    if (bufferLen <= 0) return;

    // 取len、bufferLen的最小值（为了保证数据安全，防止指针越界）
    len = (len > bufferLen) ? bufferLen : len;

    // 填充数据
    SDL_MixAudio(stream, (Uint8 *) bufferData, len, SDL_MIX_MAXVOLUME);
    bufferData += len;
    bufferLen -= len;
}

/*
SDL播放音频有2种模式：
Push（推）：【程序】主动推送数据给【音频设备】
Pull（拉）：【音频设备】主动向【程序】拉取数据
*/
void PlayThread::run() {
    // 初始化Audio子系统
    if (SDL_Init(SDL_INIT_AUDIO)) {
        qDebug() << "SDL_Init error" << SDL_GetError();
        return;
    }

    // 音频参数
    SDL_AudioSpec spec;
    // 采样率
    spec.freq = SAMPLE_RATE;
    // 采样格式（s16le）
    spec.format = AUDIO_S16LSB;
    // 声道数
    spec.channels = CHANNELS;
    // 音频缓冲区的样本数量（这个值必须是2的幂）
    spec.samples = 1024;
    // 回调
    spec.callback = pull_audio_data;
    spec.userdata = 100;

    // 打开设备
    if (SDL_OpenAudio(&spec, nullptr)) {
        qDebug() << "SDL_OpenAudio error" << SDL_GetError();
        // 清除所有的子系统
        SDL_Quit();
        return;
    }

    // 打开文件
    QFile file(FILENAME);
    if (!file.open(QFile::ReadOnly)) {
        qDebug() << "file open error" << FILENAME;
        // 关闭设备
        SDL_CloseAudio();
        // 清除所有的子系统
        SDL_Quit();
        return;
    }

    // 开始播放（0是取消暂停）
    SDL_PauseAudio(0);

    // 存放从文件中读取的数据
    char data[BUFFER_SIZE];
    while (!isInterruptionRequested()) {
        // 只要从文件中读取的音频数据，还没有填充完毕，就跳过
        if (bufferLen > 0) continue;

        bufferLen = file.read(data, BUFFER_SIZE);
        // 文件数据已经读取完毕
        if (bufferLen <= 0) break;

        // 读取到了文件数据
        bufferData = data;
    }

//    while (!isInterruptionRequested()) {
//        bufferLen = file.read(data, BUFFER_SIZE);
//        // 文件数据已经读取完毕
//        if (bufferLen <= 0) break;

//        // 读取到了文件数据
//        bufferData = data;

//        // 等待音频数据填充完毕
//        // 只要音频数据还没有填充完毕，就Delay(sleep)
//        while (bufferLen > 0) {

//        }
//    }

    // 关闭文件
    file.close();

    // 关闭设备
    SDL_CloseAudio();

    // 清除所有的子系统
    SDL_Quit();
}
