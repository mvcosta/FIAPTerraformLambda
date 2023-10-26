mkdir psycopg-download &&
cd psycopg-download/ &&
git init &&
git remote add -f origin https://github.com/jkehler/awslambda-psycopg2 &&
git config core.sparseCheckout true &&
echo "with_ssl_support/psycopg2-3.8" >> .git/info/sparse-checkout &&
git pull origin master &&
cp -r with_ssl_support/psycopg2-3.8/ ../python &&
cd .. &&
rm -rf psycopg-download &&
cd python &&
mv psycopg2-3.8/ psycopg2 &&
pip install PyJWT -t . &&
zip ../hello.zip * 
