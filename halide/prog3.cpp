#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func brightenBy(int brightenBy, Func func);
Func darkenBy(int darkenBy, Func func);
Func rgb_to_grey(Image<uint8_t> input);
void imwrite(std::string fname, int width, int height, Func continuation);

int main()
{

  std::string mStr;
  std::getline (std::cin,mStr);
  int m = atoi(mStr.c_str());

  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/Creative-Commons-Infographic.png");
  Func img1Fun("img1Fun");
  img1Fun = rgb_to_grey(input);

  Func img2Fun = brightenBy(10, img1Fun);
  Func img3Fun = darkenBy(15, img2Fun);

  imwrite("../images/prog3-out-halide.png",input.width(),input.height(), img3Fun);
  return 0;
}
