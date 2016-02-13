#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func blurX(Func func);
Func blurY(Func func);
Func brightenBy(int i, Func func);
Func rgb_to_grey(Image<uint8_t> input);
void imwrite(std::string fname, int width, int height, Func continuation);

int main()
{
  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/maisie.png");
  Func inputImg("inputImg");
  inputImg = rgb_to_grey(input);

  Func img1Fun("img1Fun");
  img1Fun(x, y, c) = cast<uint16_t>(inputImg(x, y, c));

  Func img2Fun = blurX(img1Fun);
  Func img3Fun = blurY(img2Fun);
  Func img4Fun = brightenBy(30, img3Fun);

  /* cast back down to a uint8 image */
  Func outputFun("outputFun");
  outputFun(x, y, c) = cast<uint8_t>(img4Fun(x, y, c));

  imwrite("../images/prog5-out-halide.png",input.width(),input.height(), outputFun);

  return 0;
}
