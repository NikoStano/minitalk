# 📡 Minitalk [![nistanoj's 42 minitalk Score](https://badge.nimon.fr/api/v2/cmgjygisn1482501pa9h6l9sg4/project/4399901)](https://github.com/Nimon77/badge42)

![42 Project](https://img.shields.io/badge/42-Project-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-C-orange?style=for-the-badge)
![Norm](https://img.shields.io/badge/Norm-OK-success?style=for-the-badge)

> Communication inter-processus via signaux UNIX (`SIGUSR1` & `SIGUSR2`)

---

## Structure du projet

```
minitalk/
│
├──  server.c
├──  client.c
├──  utils.c
├──  includes/
│   └──  minitalk.h
└──  Makefile
```

---

## Commandes Make

| Commande | Description |
|----------|-------------|
| `make` | Compile `server` et `client` |
| `make clean` | Supprime les fichiers objets (`.o`) |
| `make fclean` | Supprime tout (objets + exécutables) |
| `make re` | Nettoie et recompile tout |
| `make bonus` | Compile avec les bonus (identique à `make`) |
| `make test` | **Lance le testeur automatique**  |
| `make norminette` | Vérifie que le code respecte la norme 42 |

---

## Concepts appris

Ce projet permet de maîtriser :
-  Les signaux UNIX (`SIGUSR1`, `SIGUSR2`)
-  La communication inter-processus (IPC)
-  La manipulation des bits en C
-  Les variables `volatile` et `sig_atomic_t`
-  L'utilisation de `sigaction` vs `signal`
-  L'allocation dynamique de mémoire
-  Le debugging système (GDB, valgrind)

---

## Utilisation basique

**Terminal 1 - Lancer le serveur :**
```bash
./server
```

**Sortie :**
```
PID: 12345
```

**Terminal 2 - Envoyer un message :**
```bash
./client 12345 "Hello World!"
```

**Résultat dans le terminal du serveur :**
```
PID: 12345
Hello World!
```

**Résultat dans le terminal du client :**
```
Le server a recu le message !
```

---

## Comment ça marche ?

### Principe

Minitalk utilise les **signaux UNIX** pour transmettre des messages caractère par caractère, **bit par bit**.

```
CLIENT                          SERVER
  │                               │
  ├─ Envoie bit 0  (SIGUSR2) ────>│
  │<── ACK (SIGUSR2) ─────────────┤
  │                               │
  ├─ Envoie bit 1  (SIGUSR1) ────>│
  │<── ACK (SIGUSR2) ─────────────┤
  │                               │
  ... (6 autres bits)            ...
  │                               │
  │                               ├─ Caractère complet !
  │                               ├─ Affiche le caractère
```

### Encodage

- **Bit à 1** → Signal `SIGUSR1`
- **Bit à 0** → Signal `SIGUSR2`

**Exemple :** La lettre 'A' (ASCII 65 = `01000001`) :
```
Bit 7 (0) → SIGUSR2
Bit 6 (1) → SIGUSR1
Bit 5 (0) → SIGUSR2
Bit 4 (0) → SIGUSR2
Bit 3 (0) → SIGUSR2
Bit 2 (0) → SIGUSR2
Bit 1 (0) → SIGUSR2
Bit 0 (1) → SIGUSR1
```

### Protocole ACK (Accusé de réception)

Le serveur envoie un **ACK** après chaque bit reçu pour synchroniser la communication et éviter les pertes de données.

---

## Fonctionnalités

### ✅ Mandatory

- Serveur affichant son PID au lancement
- Client prenant 2 arguments : `PID` et `message`
- Transmission rapide et fiable
- Support de plusieurs clients
- Utilisation exclusive de `SIGUSR1` et `SIGUSR2`

### ✅ Bonus

- **Accusé de réception** : Le serveur confirme chaque bit reçu
- **Support Unicode** : Tous les caractères UTF-8, y compris les emoji

---

## Debugging

### Vérifier les fuites mémoire

```bash
valgrind --leak-check=full ./server
```

### Tracer les signaux

```bash
strace -e signal ./server
```

---

## Astuces

### Trouver automatiquement le PID

Au lieu de copier-coller le PID :

```bash
./client $(pgrep server) "Message"
```

### Lancer le serveur en arrière-plan

```bash
./server &
```

Pour le tuer plus tard :
```bash
kill $(pgrep server)
```

---

## Documentation complète

### **[Accéder au Wiki](../../wiki)**

Le Wiki contient toute la documentation détaillée du projet :

| Section | Description |
|---------|-------------|
| [**Home**](../../wiki/Home) | Vue d'ensemble et navigation |
| [**Installation & Utilisation**](../../wiki/Installation-&-Utilisation) | Guide complet pour compiler et utiliser |
| [**Concepts Clés**](../../wiki/Concepts-Clés) | Signaux UNIX, PID, communication bit par bit |
| [**Architecture**](../../wiki/Architecture) | Structure du projet et flux de communication |
| [**Détails Techniques**](../../wiki/Détails-Techniques) | Analyse approfondie du code |
| [**FAQ**](../../wiki/FAQ) | Réponses aux questions fréquentes |
| [**Ressources**](../../wiki/Ressources) | Commandes, outils, exemples avancés |

---
