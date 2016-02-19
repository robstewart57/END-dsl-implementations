#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func rgb_to_grey(Image<uint8_t> input);
Func brightenBy(int i, Func func);
void imwrite(std::string fname, int width, int height, Func continuation);

int main()
{
  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/Creative-Commons-Infographic.png");

  Func img1Fun("img1Fun");
  img1Fun = rgb_to_grey(input);

  Func img2Fun = brightenBy(20, img1Fun);

  imwrite("../images/prog1-out-halide.png",input.width(),input.height(), img2Fun);

  return 0;
}
