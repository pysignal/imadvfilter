# imadvfilter
Il filtro adattivo per la riduzione locale del rumore (Adaptive Local Noise Reduction Filter) è basato sulla formula:

f(x,y)=g(x,y)-vR/vL(g(x,y)-mL) con vR = varianza rumore, vL = varianza locale, mL = media locale

in cui il rapporto, tra la varianza del rumore additivo gaussiano nell’immagine e la varianza locale dell’intorno del punto di applicazione, stabilisce la quantità con cui viene modificato il valore di ogni punto dell’immagine.

Al crescere della varianza del rumore possiamo notare come il risultato cambi in relazione alla dimensioni del filtro. Per valori piccoli esso rispetta perfettamente i dettagli ma non riesce a ripulire le zone ampie prive di particolari e l’immagine appare chiazzata.

Se aumentiamo le dimensioni, le zone ampie risultano molto più uniformi e i dettagli non sono sfuocati ma, in prossimità ed in corrispondenza di questi il rumore non viene eliminato, lasciando tali zone praticamente inalterate.

Per migliorare la resa del filtro adattivo, eliminando tali problemi è stato sviluppato un nuovo algoritmo che aggiunge a quello di base il vantaggio di operare, quando è necessario, con una finestra più piccola, in prossimità ed in presenza di quei piccoli dettagli che, facendo aumentare la varianza locale ne aumentano il rapporto con la varianza del rumore, oltre una certa soglia (fornita al filtro come argomento).

Se il rapporto tra le varianze supera tale soglia, l’algoritmo prova a verificare se diminuendo le dimensioni del filtro, per quel punto, il rapporto scende di nuovo sotto soglia e, in tal caso, applica la formula base. In caso contrario continua a diminuire le dimensioni del filtro fino a raggiungere la misura minima prevista (3x3). Procede quindi alla verifica del valore del rapporto delle varianze e, se esso è maggiore di 1, applica sempre la formula base, sostituendo, in caso contrario, il valore del pixel corrente con la media dell’intorno 3x3 dello stesso.

I risultati ottenuti con il procedimento descritto sono notevoli in termini di pulizia dell’immagine e rispetto dei dettagli.
Per quantificare i risultati ottenibili dal filtro implementato, rispetto a quello base, si è provveduto ad effettuare dei test con diverse immagini (cameraman.tif, lenaBW.tif, x-ray.tif) ampiamente usate e conosciute, verificando, per ogni prova, l’errore quadratico medio ottenuto dal confronto tra l’immagine originale e quella ripulita.

I test hanno previsto l’applicazione dei due filtri sull’immagine, addizionata con rumore di varianza crescente da 0,001 a 0,010, mantenendo costante la dimensione del filtro per tale serie di valori, per poi ricominciare con una dimensione maggiore in modo da calcolare i valori ottenuti con filtri da 3x3 a 15x15.

Dall’osservazione dei dati e dei grafici ottenuti possiamo dedurre che il filtro adattivo locale avanzato produce, rispetto al già ottimo filtro adattivo locale, risultati migliori (errore quadratico medio minore) su tutte le immagini testate, soprattutto al crescere della varianza del rumore addizionato.

Per ogni immagine si può notare, inoltre, l’esistenza di un valore ottimale per la dimensione del filtro, legato alla dimensione dei dettagli.

Per contro, considerato che nella funzione di rifinitura, eseguita ricorsivamente, la dimensione della finestra di applicazione viene dimezzata ad ogni passo, la complessità dell’algoritmo aumenta nel caso peggiore (vl/vR >d per tutti i pixel e per qualsiasi dimensione dell’intorno) di un fattore logaritmico log m, con m dimensione del filtro. 

I dati sperimentali sui tempi di esecuzione, ottenuti con il profiler di MatLab, confermano tale affermazione.
