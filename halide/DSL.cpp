#include "Halide.h"
#include <stdio.h>
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;
#include "clock.h"

Func rgb_to_grey(Image<uint8_t> input)
{
  Var x("x"), y("y"), c("c"), d("d");
  Func clamped("clamped");
  clamped = BoundaryConditions::repeat_edge(input);
  Func greyImg("greyImg");
  greyImg(x,y,d) =
    clamped(x,y,0) * 0.3f
    + clamped(x,y,1) * 0.59f
    + clamped(x,y,2) * 0.11f;
  return greyImg;
}

void imwrite(std::string fname, int width, int height, Func continuation)
{
  Image<uint8_t> result(width, height, 1);

  double t1 = current_time();
  continuation.realize(result);
  double t2 = current_time();
  std::cout << ((t2 - t1) / 1000.0) << "\n";

  save_image(result, fname);
}

Func blurX(Func continuation)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  //  input_16(x, y, c) = cast<uint16_t>(continuation(x, y, c));
  Func blur_x("blur_x");
  blur_x(x, y, c) = (continuation(x-1, y, c) +
                     2 * continuation(x, y, c) +
                     continuation(x+1, y, c)) / 4;
  blur_x.vectorize(x, get_target_from_environment().natural_vector_size<uint16_t>()).parallel(y);
  blur_x.compute_root();
  // Func output("outputBlurX");
  // output(x, y, c) = cast<uint8_t>(blur_x(x, y, c));
  return blur_x;
}

Func blurY(Func continuation)
{
  Var x("x"), y("y"), c("c");
  Func input_16("input_16");
  //input_16(x, y, c) = cast<uint16_t>(continuation(x, y, c));
  Func blur_y("blur_y");
  blur_y(x, y, c) = (continuation(x, y-1, c) +
                     2 * continuation(x, y, c) +
                     continuation(x, y+1, c)) / 4;
  blur_y.vectorize(y, get_target_from_environment().natural_vector_size<uint16_t>()).parallel(x);
  blur_y.compute_root();
  Func output("outputBlurY");
  // output(x, y, c) = cast<uint8_t>(blur_y(x, y, c));
  return blur_y;
}

Func brightenBy(int brightenByVal, Func continuation)
{
  Func brighten("brighten");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = Halide::cast<float>(value);
  value = value + brightenByVal;
  value = Halide::min(value, 255.0f);
  value = Halide::cast<uint8_t>(value);
  brighten(x, y, c) = value;
  brighten.vectorize(x, get_target_from_environment().natural_vector_size<uint16_t>()).parallel(y);
  brighten.compute_root();
  return brighten;
}

Func darkenBy(int darkenByVal, Func continuation)
{
  Func darken("darken");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = Halide::cast<float>(value);
  value = value - darkenByVal;
  value = Halide::cast<uint8_t>(value);
  darken(x, y, c) = value;
  darken.vectorize(x, get_target_from_environment().natural_vector_size<uint16_t>()).parallel(y);
  darken.compute_root();
  return darken;
}
