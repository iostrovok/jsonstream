/*
Package conveyor implements a conveyor for process items step by step.
*/
package jsonstream

import (
	"errors"
	"fmt"

	_ "github.com/iostrovok/check"
)

const (
	space              = 20  // Space
	leftBrace          = 123 // {
	rightBrace         = 125 // }
	leftSquareBracket  = 91  // [
	rightSquareBracket = 93  // ]
	endLine            = 10  // \n
	quote              = 34  // "
	colon              = 58  // :
	escape             = 92  // \
	comma              = 44  // ,
)

type Reader struct {
	Body  []byte
	Total int
}

func New(b []byte) *Reader {
	return &Reader{
		Body:  b,
		Total: len(b),
	}
}

func (r *Reader) ReadLine(start int, needEscape bool) ([]byte, int, error) {
	i := start + 1
	for i < r.Total {

		fmt.Printf("r.Body[%d]: %s, %d\n", i, string(r.Body[i]), r.Body[i])

		if needEscape && r.Body[i] == escape {
			i += 2
			continue
		}

		if r.Body[i] == quote {
			return r.Body[start+1 : i], i, nil
		}

		i++
	}

	return nil, 0, errors.New(`" (end of line) is not found`)
}
