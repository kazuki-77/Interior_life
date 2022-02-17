// function 関数名(引数){処理内容}
function slideshow(target){
  // setTimeout(処理内容,実行タイミング(ミリ秒))
  // 第二引数に与えられた実行タイミング(今回は2秒)で、第一引数の処理内容を1度実行
　　setTimeout(function(){
　　  // 変数slideに targetの子要素の最後の要素を格納する
　　　　var slide = $(target).children().last();
　　　　// 変数slideを1.5秒かけてフェードアウトさせる
　　　　//
　　　　$(slide).fadeOut(1500,function(){
　　　　  // 変数slideをtargetの先頭に追加する
　　　　　　$(target).prepend(slide);
　　　　　　// slideを表示させる
　　　　　　$(slide).show();
　　　　　　// 引数(#slide-wrapper)の中身を出力する（ループさせる）
　　　　　　slideshow(target);
　　　　});
　　},2000);
}

slideshow('#slide-wrapper');