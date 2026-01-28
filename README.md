## Link Demo
https://youtu.be/05I5zyINbmM

## Sahabat Bugar - Aplikasi Fitness Mobile

Sahabat Bugar adalah aplikasi fitness mobile yang membantu pengguna untuk melakukan latihan fisik dengan panduan interaktif, tracking progress, dan motivasi. Dibangun menggunakan Flutter dan Firebase, aplikasi ini menyediakan pengalaman latihan yang terstruktur, dapat disesuaikan, serta menyimpan data secara otomatis.

## Fitur Utama:

1. Autentikasi Pengguna: Pengguna bisa masuk atau mendaftar menggunakan email dan password, dengan login yang dipertahankan di perangkat.
2. Penemuan Workout: Pengguna dapat melihat dan memilih workout sesuai tingkat kesulitan (pemula hingga lanjutan), dengan fitur pencarian dan filter.
3. Pelaksanaan Workout: Setiap workout terdiri dari beberapa latihan dengan tipe timer-based atau reps-based. Progress seperti waktu, kalori terbakar, dan status latihan ditampilkan secara real-time.
4. Tracking Progress: Aplikasi melacak total kalori terbakar, jumlah workout yang sudah diselesaikan, serta data latihan terakhir. Semua data disimpan secara lokal menggunakan SharedPreferences.
5. Motivasi dan Penghargaan: Setelah selesai workout, pengguna diberikan tampilan penghargaan yang memberikan motivasi, dengan opsi untuk melanjutkan ke halaman statistik progres.

## Arsitektur:

1. UI/Pages: Halaman utama, workout, profil, dll.
2. Business Logic: Widgets untuk filter, card workout, timer, dll.
3. Data Layer: Model untuk workout dan exercise, Firebase untuk autentikasi, dan SharedPreferences untuk data lokal.

## Alur Pengguna:

1. Pengguna login atau registrasi melalui halaman autentikasi.
2. Memilih workout, mengikuti latihan, dan melacak progresnya.
3. Setelah menyelesaikan workout, pengguna mendapatkan penghargaan dan melihat progres yang tercatat.

## Data Persistensi:

1. Firebase digunakan untuk autentikasi pengguna.
2. SharedPreferences menyimpan data pengguna dan statistik workout secara lokal.

Aplikasi ini berfokus pada pengalaman pengguna yang mudah, efektif, dan menyenangkan dengan pendekatan fitness yang lebih interaktif dan terukur.
