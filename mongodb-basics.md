# Allgemeine Infos

# Datenmodell
## Colection
Jede Datenbank word in `collections` unterteilt (was in etwa Tebellen endspricht).
Drin werden dann Dokumente abgelegt
In der Prazis sollte eine `collection` mit buchstaben oder `_` beginnen und auf keinen fall mit `?` da das `?` für andere zwecke vorbelegt ist .

# Dokumente
Dokumente sind wie ein Tupel aufgebaut ein Objekt mit Daten und eigenschaften in einer definierten reienfolge

# BSON
Formart zur übertragung , angelehnt an das [JSON](../json) formart.



# Limits
- Bson max. 4MB drüber muss GridFS genutzt werden.