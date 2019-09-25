# Uebersicht

## Pathnamen erweiterung (globbing)

* - means 'match any number of characters'. '/' is not matched (and depending on your settings, things like '.' may or may not be matched, see above)
? - means 'match any single character'
[abc] - match any of the characters listed. This syntax also supports ranges, like [0-9]

## Datein Auswerten

```sh
for filename in *.txt; do
  echo "=== BEGIN: $filename ==="
  cat "$filename"
  echo "=== END: $filename ==="
done
```

## Compound kommandos

Grouping
{ …; }	command grouping
( … )	command grouping in a subshell
Conditionals
[[ ... ]]	conditional expression
if …; then …; fi	conditional branching
case … esac	pattern-based branching
Loops
for word in …; do …; done	classic for-loop
for ((x=1; x<=10; x++)); do ...; done	C-style for-loop
while …; do …; done	while loop
until …; do …; done	until loop
Misc
(( ... ))	arithmetic evaluation
select word in …; do …; done	user selections

## Expansion und substitution

{A,B,C} {A..C}	Brace expansion
~/ ~root/	Tilde expansion
$FOO ${BAR%.mp3}	Parameter expansion
`command` $(command)	Command substitution
<(command) >(command)	Process substitution
$((1 + 2 + 3)) $[4 + 5 + 6]	Arithmetic expansion
Hello <---> Word!	Word splitting
/data/*-av/*.mp?	Pathname expansion

## Process substitution

```sh
<( <LIST> )

>( <LIST> )
```

## Example mit diff

`diff <(ls "$first_directory") <(ls "$second_directory")`

## Example als counter

```sh
counter=0

while IFS= read -rN1 _; do
    ((counter++))
done < <(find /etc -printf ' ')

echo "$counter files"
```

## Zuweisung via Parameter

```sh
f() {
    cat "$1" >"$x"
}

x=>(tr '[:lower:]' '[:upper:]') f <(echo 'hi there')
```

## Parameter expansion

**Simple usage**
        $PARAMETER
        ${PARAMETER}

**Indirection**
        ${!PARAMETER}

**Case modification**
        ${PARAMETER^}
        ${PARAMETER^^}
        ${PARAMETER,}
        ${PARAMETER,,}
        ${PARAMETER~}
        ${PARAMETER~~}

**Variable name expansion**
        ${!PREFIX*}
        ${!PREFIX@}

**Substring removal (also for filename manipulation!)**
        ${PARAMETER#PATTERN}
        ${PARAMETER##PATTERN}
        ${PARAMETER%PATTERN}
        ${PARAMETER%%PATTERN}

**Search and replace**
        ${PARAMETER/PATTERN/STRING}
        ${PARAMETER//PATTERN/STRING}
        ${PARAMETER/PATTERN}
        ${PARAMETER//PATTERN}

**String length**
        ${#PARAMETER}

**Substring expansion**
        ${PARAMETER:OFFSET}
        ${PARAMETER:OFFSET:LENGTH}

**Use a default value**
        ${PARAMETER:-WORD}
        ${PARAMETER-WORD}

**Assign a default value**
        ${PARAMETER:=WORD}
        ${PARAMETER=WORD}

**Use an alternate value**
        ${PARAMETER:+WORD}
        ${PARAMETER+WORD}

## Display error if null or unset

* `${PARAMETER:?WORD}`
* `${PARAMETER?WORD}`

**Get name without extension**
`${FILENAME%.*}`

**Get extension**
`${FILENAME##*.}`

**Get directory name**
`${PATHNAME%/*}`

**Get filename**
`${PATHNAME##*/}`

## Brace expansion

```sh
$ echo _{I,want,my,money,back}
_I _want _my _money _back

$ echo {I,want,my,money,back}_
I_ want_ my_ money_ back_

$ echo _{I,want,my,money,back}-
_I- _want- _my- _money- _back-
```

`echo {{A..Z},{a..z}}`

`echo {A..Z}{0..9}`

`{<START>..<END>}`

## Search and replace

```sh
${PARAMETER/PATTERN/STRING}

${PARAMETER//PATTERN/STRING}

${PARAMETER/PATTERN}

${PARAMETER//PATTERN}
```

## Arrays

**Quellen:**

* [bash-hackers.org](https://wiki.bash-hackers.org/syntax/pe)

## Tools

* [bash-templater](https://github.com/lavoiesl/bash-templater)