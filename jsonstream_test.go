package jsonstream_test

import (
	"fmt"
	"testing"

	. "github.com/iostrovok/check"
	_ "github.com/iostrovok/check"

	"github.com/iostrovok/jsonstream"
)

type testSuite struct{}

var _ = Suite(&testSuite{})

func TestP(t *testing.T) { TestingT(t) }

const (
	line1 = `{"string":"super normal string"}`
)

func (s *testSuite) TestUniqueStringList(c *C) {

	reader := jsonstream.New([]byte(line1))

	res, point, err := reader.ReadLine(10, false)


	for i, v:= range []byte(line1) {
		fmt.Printf("%d: %s\n",  i, string(v))
	}


	fmt.Printf("\n\n%s\n\n", string(res))
	fmt.Printf("\n\npoint: %d\n\n", point)
	fmt.Printf("\n\nerr: %+v\n\n", err)

	c.Assert(err, IsNil)
	c.Assert(string(res), DeepEquals, "super normal string")
}
