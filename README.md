# 📡 Minitalk

![42 Project](https://img.shields.io/badge/42-Project-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-C-orange?style=for-the-badge)
![Norm](https://img.shields.io/badge/Norm-OK-success?style=for-the-badge)

> Communication inter-processus via signaux UNIX (`SIGUSR1` & `SIGUSR2`)

---

## 📖 Documentation complète

### 📚 **[Accéder au Wiki](../../wiki)**

Le Wiki contient toute la documentation détaillée du projet :

| Section | Description |
|---------|-------------|
| 🏠 [**Home**](../../wiki/Home) | Vue d'ensemble et navigation |
| 🚀 [**Installation & Utilisation**](../../wiki/Installation-&-Utilisation) | Guide complet pour compiler et utiliser |
| 🧠 [**Concepts Clés**](../../wiki/Concepts-Clés) | Signaux UNIX, PID, communication bit par bit |
| 🏗️ [**Architecture**](../../wiki/Architecture) | Structure du projet et flux de communication |
| 🔧 [**Détails Techniques**](../../wiki/Détails-Techniques) | Analyse approfondie du code |
| ❓ [**FAQ**](../../wiki/FAQ) | Réponses aux questions fréquentes |
| 🎓 [**Ressources**](../../wiki/Ressources) | Commandes, outils, exemples avancés |

---

## ⚡ Quick Start

### Compilation

```bash
make
```

Génère deux exécutables : `server` et `client`

### Utilisation basique

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

## 🧪 Tester le projet

### Testeur automatique intégré

Le Makefile inclut une commande `test` qui **télécharge automatiquement** un testeur complet et l'exécute :

```bash
make test
```

### Ce que fait `make test` :

1. **Compile** le projet (`server` et `client`)
2. **Clone** le repository de test depuis GitHub :
   ```
   https://github.com/NikoStano/minitalk-tester.git
   ```
3. **Lance le serveur** en arrière-plan
4. **Exécute** une batterie de tests automatiques :
   - Messages simples
   - Messages longs
   - Caractères spéciaux
   - Unicode et emoji
   - Tests de performance
5. **Tue** proprement le serveur
6. **Nettoie** tout (supprime le testeur et les fichiers temporaires)

### Sortie attendue :

```bash
╔════════════════════════════════════╗
║     Launching test on MINITALK     ║
╚════════════════════════════════════╝
[ → ] Cloning minitalk...
[ ℹ ] Launching server in background...
[ ℹ ] Running tests with PID 12345
...
[Tests s'exécutent automatiquement]
...
[ → ] All tests ran! Cleaning up...
[ ✓ ] All tests completed
```

### Avantages du testeur automatique :

- ✅ **Aucune installation manuelle** : Tout se fait automatiquement
- ✅ **Tests complets** : Couvre tous les cas d'usage
- ✅ **Nettoyage automatique** : Pas de fichiers qui traînent
- ✅ **Facile à relancer** : Une seule commande

---

## 🔧 Commandes Make

| Commande | Description |
|----------|-------------|
| `make` | Compile `server` et `client` |
| `make clean` | Supprime les fichiers objets (`.o`) |
| `make fclean` | Supprime tout (objets + exécutables) |
| `make re` | Nettoie et recompile tout |
| `make bonus` | Compile avec les bonus (identique à `make`) |
| `make test` | **Lance le testeur automatique** 🧪 |
| `make norminette` | Vérifie que le code respecte la norme 42 |

---

## 📋 Exemples d'utilisation

### Messages divers

```bash
# Message simple
./client $(pgrep server) "Bonjour !"

# Message avec accents
./client $(pgrep server) "Ça marche très bien !"

# Emoji et Unicode
./client $(pgrep server) "Hello 🌍 World 🚀"

# Message long
./client $(pgrep server) "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."
```

### Envoyer plusieurs messages

```bash
./client $(pgrep server) "Premier message"
./client $(pgrep server) "Deuxième message"
./client $(pgrep server) "Troisième message"
```

---

## 🏗️ Comment ça marche ?

### Principe

Minitalk utilise les **signaux UNIX** pour transmettre des messages caractère par caractère, **bit par bit**.

```
CLIENT                          SERVER
  │                               │
  ├─ Envoie bit 0 (SIGUSR2) ────>│
  │<── ACK (SIGUSR2) ─────────────┤
  │                               │
  ├─ Envoie bit 1 (SIGUSR1) ────>│
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

## 📊 Fonctionnalités

### ✅ Mandatory

- Serveur affichant son PID au lancement
- Client prenant 2 arguments : `PID` et `message`
- Transmission rapide et fiable
- Support de plusieurs clients
- Utilisation exclusive de `SIGUSR1` et `SIGUSR2`

### ✅ Bonus

- **Accusé de réception** : Le serveur confirme chaque bit reçu
- **Support Unicode** : Tous les caractères UTF-8, y compris les emoji 🚀

---

## 🐛 Debugging

### Vérifier la norme

```bash
make norminette
```

**Sortie si tout est OK :**
```
[ ℹ ] Running norminette...
[ ✓ ] Norminette passed!
[ ℹ ] Norminette check completed.
```

### Vérifier les fuites mémoire

```bash
valgrind --leak-check=full ./server
```

### Tracer les signaux

```bash
strace -e signal ./server
```

---

## 💡 Astuces

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

### Tester rapidement

```bash
# Script pour envoyer plusieurs messages
for i in {1..5}; do
    ./client $(pgrep server) "Test $i"
    sleep 0.3
done
```

---

## 📈 Performance

- **Vitesse** : ~100-120 caractères par seconde
- **Fiabilité** : ACK garantit la réception de chaque bit
- **Support Unicode complet** : UTF-8, emoji, caractères spéciaux

---

## 🔗 Structure du projet

```
minitalk/
│
├── 📄 server.c              # Programme serveur
├── 📄 client.c              # Programme client
├── 📄 utils.c               # Fonctions utilitaires (ft_putstr, etc.)
│
├── 📁 includes/
│   └── 📄 minitalk.h        # Header principal
│
├── 🔧 Makefile              # Compilation et tests
└── 📖 README.md             # Ce fichier
```

---

## 📚 Pour aller plus loin

### Consulter le Wiki

Le **[Wiki complet](../../wiki)** contient :
- Des explications détaillées sur les signaux UNIX
- Des diagrammes de flux de communication
- Une analyse ligne par ligne du code
- Des exemples avancés
- Des exercices pratiques
- Des ressources pour approfondir

### Man pages utiles

```bash
man signal      # Gestion des signaux
man sigaction   # Signal handling avancé
man kill        # Envoi de signaux
man pause       # Attente passive
```

---

## 🎓 Concepts appris

Ce projet permet de maîtriser :
- ⚡ Les signaux UNIX (`SIGUSR1`, `SIGUSR2`)
- 🔄 La communication inter-processus (IPC)
- 🔢 La manipulation des bits en C
- 💾 Les variables `volatile` et `sig_atomic_t`
- 🔧 L'utilisation de `sigaction` vs `signal`
- 🧠 L'allocation dynamique de mémoire
- 🐛 Le debugging système (GDB, valgrind)

---

## 👤 Auteur

**nistanoj** - [École 42](https://42.fr)

---

_N'oubliez pas de consulter le [Wiki](../../wiki) pour toute question !_
