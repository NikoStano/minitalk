## MINITALK TO_DO LIST

# NOTIONS
- [x] check comment marche les signaux`SIGUSR1` `SIGUSR2`

# MANDATORY
- [x] creer l'exec server et au lancement affiche le `PID` dans le `TERMINAL` initial
- [x] le `CLIENT` prend 2 args `PID` `STR`
- [x] le `CLIENT` transmet au `SERVER` avec le `PID` une `STR` et le server doit l'afficher (`RAPIDEMENT`)
- [x] `PLUSIEURS CLIENT` peuvent communiquer avec un server
- [x] Utiliser uniquement les signaux `UNIX`  `SIGUSR1` et `SIGUSR2`

# BONUS
- [x] `SERVER` confirme la reception avec un signal au `CLIENT` 
- [x] Gestion des caractere `UNICODE`


### Tester 👇
```bash
make test
```