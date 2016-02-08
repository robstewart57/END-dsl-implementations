#include "Halide.h"
#include <stdio.h>
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Image<uint8_t> blurX(Image<uint8_t> input)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  input_16(x, y, c) = cast<uint16_t>(input(x, y, c));
  Func blur_x("blur_x");
  blur_x(x, y, c) = (input_16(x-1, y, c) +
                     2 * input_16(x, y, c) +
                     input_16(x+1, y, c)) / 4;
  Func output("output");
  output(x, y, c) = cast<uint8_t>(blur_x(x, y, c));
  Image<uint8_t> result(input.width()-2, input.height()-2, 3);
  result.set_min(1, 1);
  output.realize(result);
  return result;
}


Image<uint8_t> blurY(Image<uint8_t> input)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  input_16(x, y, c) = cast<uint16_t>(input(x, y, c));
  Func blur_y("blur_y");
  blur_y(x, y, c) = (input_16(x, y-1, c) +
                     2 * input_16(x, y, c) +
                     input_16(x, y+1, c)) / 4;
  Func output("output");
  output(x, y, c) = cast<uint8_t>(blur_y(x, y, c));
  Image<uint8_t> result(input.width()-2, input.height()-2, 3);
  result.set_min(1, 1);
  output.realize(result);
  return result;
}

Image<uint8_t> brightenBy(Image<uint8_t> input, float brightenBy)
{
    Func brighter;
    Var x, y, c;
    Expr value = input(x, y, c);
    value = Halide::cast<float>(value);
    value = value * 1.5f;
    value = Halide::min(value, 255.0f);
    value = Halide::cast<uint8_t>(value);
    brighter(x, y, c) = value;
    Image<uint8_t> output = brighter.realize(input.width(), input.height(), input.channels());
    return output;
}
