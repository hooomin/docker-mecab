FROM python:3.5-alpine
MAINTAINER hoomin <kanichan22@outlook.jp>

ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
RUN apk add --no-cache curl openssl-dev make less libffi-dev musl-dev gcc bash file sudo build-base

#Install mecab
RUN curl -L -o mecab-0.996.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE'
RUN tar -zxf mecab-0.996.tar.gz
WORKDIR mecab-0.996
RUN  ./configure --enable-utf8-only --with-charset=utf8
RUN make
RUN make check
RUN make install

#Install IPA dic
RUN  curl -SL -o mecab-ipadic-2.7.0-20070801.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM' \
&& tar zxf mecab-ipadic-2.7.0-20070801.tar.gz \
&& cd mecab-ipadic-2.7.0-20070801 \
&& ./configure --with-charset=utf8 \
&& make \
&& make install

WORKDIR /code
ADD requirements.txt /code/
#RUN ./configure --with-charset=utf8 --with-mecab-config=/usr/local/bin/mecab-config
RUN pip install -r requirements.txt
ADD . /code/
