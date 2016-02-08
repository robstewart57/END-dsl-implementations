#include "Halide.h"
#include <stdio.h>
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;


Func blurX(Func continuation)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  input_16(x, y, c) = cast<uint16_t>(continuation(x, y, c));
  Func blur_x("blur_x");
  blur_x(x, y, c) = (input_16(x-1, y, c) +
                     2 * input_16(x, y, c) +
                     input_16(x+1, y, c)) / 4;
  // blur_x.vectorize(x, 4);
  // returns error:
  //   Cannot vectorize dimension x.v3 of function blur_x because the function is scheduled inline.

  // blur_x.unroll(x);
  // returns error:
  //   Cannot unroll dimension x of function blur_x because the function is scheduled inline.
  Func output("outputBlurX");
  output(x, y, c) = cast<uint8_t>(blur_x(x, y, c));
  return output;
}

Func blurY(Func continuation)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  input_16(x, y, c) = cast<uint16_t>(continuation(x, y, c));
  Func blur_y("blur_y");
  blur_y(x, y, c) = (input_16(x, y-1, c) +
                     2 * input_16(x, y, c) +
                     input_16(x, y+1, c)) / 4;
  // blur_y.vectorize(y, 4);
  Func output("outputBlurY");
  output(x, y, c) = cast<uint8_t>(blur_y(x, y, c));
  return output;
}

Func brightenBy(Func continuation, float brightenByVal)
{
  Func brighten("brighten");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = Halide::cast<float>(value);
  value = value * brightenByVal;
  value = Halide::min(value, 255.0f);
  value = Halide::cast<uint8_t>(value);
  brighten(x, y, c) = value;
  // brighten.vectorize(x, 4);
  return brighten;
}

Func darkenBy(Func continuation, float darkenByVal)
{
  Func brighten("brighten");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = Halide::cast<float>(value);
  value = value * (-darkenByVal);
  value = Halide::cast<uint8_t>(value);
  brighten(x, y, c) = value;
  return brighten;
}
