import java.util.ArrayList;
import processing.sound.*;

ArrayList<Cokroach> coks;
PImage img, imgtinju, ground;
PImage gameTitle;
SoundFile soundFX, backSound;
int lastSpawnTime;
float tinjuWidth = 70;
float tinjuHeight = 100;
boolean gameStarted = false;
int score = 0; // Variabel untuk menyimpan skor
int level = 1; // Variabel untuk menyimpan level, dimulai dari 1
int spawnInterval = 5000; // Interval spawn awal dalam milidetik

void setup() {
  size(800, 800);
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");
  imgtinju = loadImage("tinju.png");
  ground = loadImage("ground.png");
  gameTitle = loadImage("gameTitle.png");
  soundFX = new SoundFile(this, "soundFX.mp3");
  backSound = new SoundFile(this, "back.mp3");
  backSound.loop();
  lastSpawnTime = millis();
  cursor();
}

void draw() {
  if (!gameStarted) {
    showStartScreen();
  } else {
    noCursor();
    imageMode(CORNER);
    image(ground, 0, 0, width, height);

    // Tombol Exit
    fill(34, 139, 34);
    rectMode(CORNER);
    rect(20, 20, 80, 40);

    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Exit", 20 + 40, 20 + 20);

    // Menampilkan skor di tengah atas
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Score: " + score, width / 2, 50);

    // Menampilkan level di pojok kanan atas
    textAlign(RIGHT, TOP);
    text("Level: " + level, width - 20, 20);

    // Spawn kecoak sesuai interval yang diatur
    if (millis() - lastSpawnTime > spawnInterval) {
      for (int i = 0; i < level; i++) { // Spawn kecoak sebanyak nilai level
        float x = random(width);
        float y = random(height);
        coks.add(new Cokroach(img, x, y));
      }
      lastSpawnTime = millis();
    }

    // Menggerakkan kecoak
    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      c.live();

      if (!c.isAlive()) {
        coks.remove(i);
      }
    }

    fill(51);
    textSize(16);
    text("nums: " + coks.size(), 50, 750);

    // Menampilkan tinju pada posisi mouse
    imageMode(CENTER);
    image(imgtinju, mouseX, mouseY, tinjuWidth, tinjuHeight);

    // Area deteksi tinju
    float tinjuTipX = mouseX;
    float tinjuTipY = mouseY + tinjuHeight / 2 - 75;
    noFill();
    noStroke();
    ellipse(tinjuTipX, tinjuTipY, 30, 30);
  }
}

void mouseClicked() {
  if (!gameStarted) {
    float playX = width / 2;
    float playY = height / 2 + 80;
    float exitX = width / 2;
    float exitY = height / 2 + 130;

    if (dist(mouseX, mouseY, playX, playY) < 50) {
      gameStarted = true;
      noCursor();
    } else if (dist(mouseX, mouseY, exitX, exitY) < 50) {
      exit();
    }
  } else {
    if (mouseX > 20 && mouseX < 100 && mouseY > 20 && mouseY < 60) {
      gameStarted = false;
      cursor();
    }

    boolean hit = false;
    float tinjuTipX = mouseX;
    float tinjuTipY = mouseY + tinjuHeight / 2 - 75;

    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      if (dist(tinjuTipX, tinjuTipY, c.getX(), c.getY()) < 30) {
        c.die();
        hit = true;
        score++; // Tambah skor saat kecoak dibunuh

        // Naikkan level setiap kelipatan 10 skor
        if (score % 10 == 0) {
          level++;
          spawnInterval = max(1000, spawnInterval / 2); // Kurangi interval spawn (2x lebih cepat setiap level)
        }
      }
    }

    if (hit) {
      soundFX.play();
    }
  }
}

void showStartScreen() {
  imageMode(CORNER);
  image(ground, 0, 0, width, height);

  imageMode(CENTER);
  image(gameTitle, width / 2, height / 2 - 50);

  fill(34, 139, 34);
  rectMode(CENTER);
  rect(width / 2, height / 2 + 110, 100, 40);

  rect(width / 2, height / 2 + 160, 100, 40);

  fill(255);
  textSize(32);
  textAlign(CENTER);
  textFont(createFont("Arial-Bold", 32));
  text("Play", width / 2, height / 2 + 118);
  text("Exit", width / 2, height / 2 + 168);
}
