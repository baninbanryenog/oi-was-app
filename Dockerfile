# Python 3.11 slim 베이스
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# 빌드 도구 약간 필요할 수 있음 (pymysql, psycopg2 등 쓰면 조정)
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 의존성 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 앱 복사
COPY . .

# (선택) 헬스엔드포인트가 /healthz 라우트라면 gunicorn 준비 시간 단축됨
EXPOSE 8000

# gunicorn 엔트리포인트 (필요 시 -w, -k 값 조정)
CMD ["gunicorn","-w","2","-k","gthread","-b","0.0.0.0:8000","app:app"]
