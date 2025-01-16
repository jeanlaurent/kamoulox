package main

import (
	"fmt"
	"math/rand"
	"unicode"
)

func main() {
	kamoulox := Kamoulox{}
	fmt.Println(kamoulox.Generate())
}

// Kamoulox generates a famous kamoulox sentence
type Kamoulox struct{}

func (k *Kamoulox) Generate() string {
	firstVerb := randomElementFrom(verbs)
	firstObject := randomElementFrom(objects)
	return fmt.Sprintf("%s %s et %s %s.", capitalizeFirst(firstVerb), firstObject, randomElementFromExcluding(verbs, firstVerb), randomElementFromExcluding(objects, firstObject))
}

func randomElementFrom(array []string) string {
	return array[rand.Intn(len(array))]
}

func capitalizeFirst(str string) string {
	for i, v := range str {
		return string(unicode.ToUpper(v)) + str[i+1:]
	}
	return ""
}

func randomElementFromExcluding(array []string, toExclude string) string {
	found := array[rand.Intn(len(array))]
	if found != toExclude {
		return found
	}
	return randomElementFromExcluding(array, toExclude)
}
