#wget -O cah-ugly-white.json 'https://www.reddit.com/r/cahideas/search.json?q=flair:White+Card&restrict_sr=true&limit=100'
#wget -O cah-ugly-black.json 'https://www.reddit.com/r/cahideas/search.json?q=flair:Black+Card&restrict_sr=true&limit=100'
wget -O cah-ugly-white.json 'https://www.reddit.com/r/cahideas/search.json?q=\[w\]&restrict_sr=true&limit=100'
wget -O cah-ugly-black.json 'https://www.reddit.com/r/cahideas/search.json?q=\[b\]&restrict_sr=true&limit=100'
cat cah-ugly-white.json | python -m json.tool > cah-pretty-white.json
cat cah-ugly-black.json | python -m json.tool > cah-pretty-black.json
sed -i "s/\[\[/\[/g" cah-pretty-black.json
sed -i "s/\[\[/\[/g" cah-pretty-white.json
sed -i "s/\]\]/\]/g" cah-pretty-black.json
sed -i "s/\]\]/\]/g" cah-pretty-white.json
cat cah-pretty-white.json | grep \"title\" > cah-white-q.txt
cat cah-pretty-black.json | grep \"title\" > cah-black-q.txt

sed 's/"//g' cah-white-q.txt > cah-white.txt
sed 's/"//g' cah-black-q.txt > cah-black.txt

sed -i "s/\://g" cah-white.txt
sed -i "s/\[W\]//g" cah-white.txt
sed -i "s/\[w\]//g" cah-white.txt
sed -i "s/\(self\.cahideas\)//g" cah-white.txt
sed -i "s/()//g" cah-white.txt
sed -i "s/\\\\//g" cah-white.txt
sed -i "s/u2018/\‘/g" cah-white.txt
sed -i "s/u2019/\'/g" cah-white.txt
sed -i "s/u200b//g" cah-white.txt
sed -i "s/u201c/\“/g" cah-white.txt
sed -i "s/u201d/\”/g" cah-white.txt
sed -i "s/\&amp\;/\&/g" cah-white.txt
sed -i "s/White Card //g" cah-white.txt
sed -i "s/\"/\"/g" cah-white.txt
sed -i "s/                    //g" cah-white.txt
sed -i "s/title  //g" cah-white.txt
sed -i "s/.$//" cah-white.txt
sed -i "s/\"/\“/g" cah-white.txt
sed -i '/[B]/d' cah-white.txt
sed -i '/[b]/d' cah-white.txt


sed -i "s/\://g" cah-black.txt
sed -i "s/\[B\]//g" cah-black.txt
sed -i "s/\[b\]//g" cah-black.txt
sed -i "s/\(self\.cahideas\)//g" cah-black.txt
sed -i "s/()//g" cah-black.txt
sed -i "s/\\\\//g" cah-black.txt
sed -i "s/u2018/\‘/g" cah-black.txt
sed -i "s/u2019/\'/g" cah-black.txt
sed -i "s/u200b//g" cah-black.txt
sed -i "s/u201c/\“/g" cah-black.txt
sed -i "s/u201d/\”/g" cah-black.txt
sed -i "s/\&amp\;/\&/g" cah-black.txt
sed -i "s/Black Card //g" cah-black.txt
sed -i "s/\"/\"/g" cah-black.txt
sed -i "s/                    //g" cah-black.txt
sed -i "s/title  //g" cah-black.txt
sed -i "s/.$//" cah-black.txt
sed -i "s/\"/\“/g" cah-black.txt
sed -i '/[W]/d' cah-black.txt
sed -i '/[w]/d' cah-black.txt

mv cah-black.txt cah-black-spaces.txt
awk '$1=$1' FS='[_]*' OFS=_____ cah-black-spaces.txt > cah-black.txt

while read f; do
 if [[ `cat white.txt | grep -c "$f"` > 0 ]];then
  :
 else
  echo "Adding card $f"
  echo "$f" >> white.txt
 fi
done < cah-white.txt

while read f; do
 if [[ `cat black.txt | grep -c "$f"` > 0 ]];then
  :
 else
  echo "Adding card $f"
  echo "$f" >> black.txt
 fi
done < cah-black.txt

rm -f reddit-cah-ideas.json
touch reddit-cah-ideas.json

cat << EOF >> reddit-cah-ideas.json
{
    "id": "reddit_pack",
    "name": "Reddit CAH Ideas Pack",
    "accent_background": "#fc033d",
    "accent_color": "#ffffff",
    "author": "r/cahideas",
    "cards": [

EOF

while read f; do
echo "{\"id\": \"b_$a\",\"content\": {\"en\": \"${f}\" }}," >> reddit-cah-ideas.json
a=`echo $(( $a + 1 ))`
done < black.txt

while read f; do
echo "{\"id\": \"w_$a\",\"content\": {\"en\": \"${f}\" }}," >> reddit-cah-ideas.json
a=`echo $(( $a + 1 ))`
done < white.txt


cat << EOF >> reddit-cah-ideas.json
{"id": "b_gitcommit","content": {"en": "My last Git commit message: \"Added _____.\""},}]}

EOF

rm -f cah*
