## IE1 Corrector
m5211143 Tomohiro Saito

### memo
IE03 Integrated Software I

s1220041,森藤　馨,Kaoru Morito
s1220057,濱田　真友子,Mayuko Hamada
s1230027,小川　風太,Futa Ogawa,https://github.com/futyPnd
s1230044,石井　和馬,Kazuma Ishii,https://github.com/slme9364
s1230047,大石　智士,Satoshi Oishi,			
s1230110,唐鎌　駿冴,Shungo Karakama,
s1230147,伊東　純,Jun Ito,
s1230165,横山　裕音,Hiroto Yokoyama,
s1230206,吉田　達哉,Tatsuya Yoshida,
s1230220,並河　芳樹,Yoshiki Namikawa,https://github.com/Y-namikawa
s1230244,水越　望斗,Boto Mizukoshi,https://github.com/zkzi3254
s1240021,赤津　悠太,Yuta Akatsu,https://github.com/s1240021  
s1240042,石井　祐伍,Yugo Ishii,https://github.com/yng110
s1240066,影山　琢馬,Takuma Kageyama,https://github.com/ukuku09
s1240075,棗　光幹,Koki Natsume,https://github.com/natumn
s1240089,齊藤　俊毅,Toshiki Saito,
s1240099,村上　貴広,Takahiro Murakami,
s1240139,森田　北斗,Hokuto Morita,https://github.com/HokutoMorita
s1240154,西山　諒,Ryo Nishiyama,
s1240155,馬場　義道,Yoshimichi Baba,https://github.com/s1240155  
s1240158,松﨑　覚,Satoru Matsuzaki,https://github.com/s1240158
s1240159,森本　望,Nozomi Morimoto,https://github.com/nozomi0966
s1240181,有我　主樹,Kazuki Ariga,https://github.com/s1240181   
s1240188,小林　徹也,Tetsuya Kobayashi,https://github.com/bayashiP
s1240192,高畑　凌風,Shinobu Takahata,
s1240203,臼井　昭仁,Akihito Usui,https://github.com/aki0927
s1240210,白井　友貴,Tomoki Shirai,	https://github.com/c7c7c7c7
s1240216,前田　桜花,Oka Maeda,https://github.com/maedaouka

GitHub API

curl -o out1.json -v -H "Authorization: token be84762b9055050048a46f671e9411b920d92708" https://api.github.com/orgs/ie03-aizu/members?page=1\&per_page=100
curl -o out2.json -v -H "Authorization: token be84762b9055050048a46f671e9411b920d92708" https://api.github.com/orgs/ie03-aizu/members?page=2\&per_page=100

授業のメーリングリストのcsvとGitHub classroom のexcelを食わせ、対象のクラスを入力すると、自動的にリポジトリから対象の生徒が参加しているチームのプロジェクトのリポジトリをローカルに全てクローンしてくる

### 仕様
入力：
メーリングリストからダウンロードしたcsvファイル
GitHub Classroomからダウンロードしたcsvファイル

二つの入力を元に、特定の演習室の履修生のみの[学籍番号, GitHubアカウントID]となるリストを作成

### GitHub認証
アクセストークンの取得方法:
http://tetu1984.hateblo.jp/entry/2012/09/30/235233
