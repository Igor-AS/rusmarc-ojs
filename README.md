# rusmarc-ojs
Конвертирует статьи и выпуски из mrc (rusmarc) в xml OJS (Open Journal Systems)


yaz-marcdump -i marc -o marcxml bulletin_tpu-2012-v320-i1.mrc >issue-2012-v320-i1.xml

xsltproc issue.xsl issue-2012-v320-i1.xml >OJS-issue.xml


Протестировано на OJS 3.1.2.


RUSMARC российская версия UNIMARC http://rusmarc.ru

Open Journal Systems (OJS) https://pkp.sfu.ca/ojs/
