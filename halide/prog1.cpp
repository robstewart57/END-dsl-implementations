#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func blurX(Func func);

int main()
{
  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/maisie.png");
  Func clamped("clamped");
  clamped = BoundaryConditions::repeat_edge(input);

  Func img1Fun("img1Fun");
  img1Fun(x, y, c) = cast<uint16_t>(clamped(x, y, c));

  /* blur the image */
  Func img2Fun = blurX(img1Fun);

  /* cast back down to a uint8 image */
  Func outputFun("outputFun");
  outputFun(x, y, c) = cast<uint8_t>(img2Fun(x, y, c));

  Image<uint8_t> result(input.width(), input.height(), 3);

  outputFun.realize(result);
  save_image(result, "../images/prog1-out-halide.png");
  return 0;
}
