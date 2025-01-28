package kamoulox

import (
	"fmt"
	"strings"
	"unicode"

	"math/rand"
)

func GenerateKamoulox() string {
	numPairs := rand.Intn(3) + 2 // Generate between 2 and 4 pairs
	usedVerbs := make([]string, 0, numPairs)
	usedObjects := make([]string, 0, numPairs)
	pairs := make([]string, 0, numPairs)

	for i := 0; i < numPairs; i++ {
		verb := randomElementFromExcluding(verbs, usedVerbs...)
		object := randomElementFromExcluding(objects, usedObjects...)
		usedVerbs = append(usedVerbs, verb)
		usedObjects = append(usedObjects, object)
		if i == 0 {
			verb = capitalizeFirst(verb)
		} else {
			verb = strings.TrimPrefix(verb, "je ")
			verb = strings.TrimPrefix(verb, "j'")
		}
		pair := fmt.Sprintf("%s %s", verb, object)
		pairs = append(pairs, pair)
	}

	sentence := strings.Join(pairs[:len(pairs)-1], ", ")
	sentence += " et " + pairs[len(pairs)-1] + "."
	return sentence
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
func randomElementFromExcluding(array []string, toExclude ...string) string {
	for {
		found := array[rand.Intn(len(array))]
		exclude := false
		for _, ex := range toExclude {
			if found == ex {
				exclude = true
				break
			}
		}
		if !exclude {
			return found
		}
	}
}
