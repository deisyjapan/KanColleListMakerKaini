# 艦これ一覧めいかー改二 (KanColleListMakerKaini)

艦これ一覧めいかー改二はWindows上で動作する艦隊これくしょん -艦これ-の補助をするツールです。  
スクリーンショットの撮影、それを利用した艦隊、所持艦娘のまとめ画像の作成、Twitterへの投稿、動画キャプチャなどの機能を持っています。

## ダウンロード

<s>全てのバージョンは以下の場所からダウンロード出来ます。
- https://ux.getuploader.com/KanColleListMakerKaini/</s>

※2022/01/03現在、上記URLは削除され配布所が存在しなくなっているようです。

## コンパイル環境
艦これ一覧めいかー改二をコンパイルするには次のソフトが必要です。
- **[Hot Soup Processor](http://hsp.tv/)** (>=3.51)

**Ver0.9からソースコードがUTF-8になりました。  
UTF-8で記述されたソースは標準のスクリプトエディタでは編集/コンパイルができませんのでお気をつけ下さい。**


## プライバシーポリシー
本ソフトウェアはWebサービスではなく、PC上でネイティブ動作するソフトウェアです。  
情報を外部へ送信する機能は無く、個人情報の収集は行いません。  
Twitter連携を行った場合の認証情報は、簡易的な暗号化を行った上で個々のPC上に保存されます。

## Privacy Policy(English)
This software is not a web service but a software that runs natively on a PC.  
There is no function to transmit information to the outside, and no personal information is collected.  
Authentication information when Twitter is linked is stored on each PC after simple encryption.  
If there is a difference between the Japanese and English versions of this privacy policy, the Japanese version will take precedence.  

## ライセンス
Copyright 2017 kanahiron

Code licensed under the MIT License, see LICENSE.txt.

Icon licensed under CC BY-ND 4.0: https://creativecommons.org/licenses/by-nd/4.0/

## deisysoftによる修正
・Twitter連携機能は連携用アカウント消失により使えなくなったため、削除しています。
・Twitter連携機能は使えなくしていますが、コード上認証情報を保存する処理自体は残っています。
・(2023/11/12)ウィンドウにフォルダをD%Dしたとき、[SS保存先][一覧保存先][連続キャプチャ保存先][範囲選択キャプチャ保存先]の設定をD&Dしたフォルダに変更する機能を追加しています。



## NVENC対応
ffmpegがNVENCに対応している必要があります。
- **[Builds - CODEX FFMPEG @ gyan.dev](https://www.gyan.dev/ffmpeg/builds/)** より最新版をダウンロードしてください。
