#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func blurX(Func func);
Func rgb_to_grey(Image<uint8_t> input);
void imwrite(std::string fname, int width, int height, Func continuation);

int main()
{
  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/Creative-Commons-Infographic.png");
  Func img1Fun("img1Fun");
  img1Fun = rgb_to_grey(input);

  /* blur the image */
  Func img2Fun = blurX(img1Fun);

  /* blur again */
  Func img3Fun = blurX(img2Fun);

  imwrite("../images/prog2-out-halide.png",input.width(),input.height(), img3Fun);

  return 0;
}
