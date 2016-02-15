#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func brightenBy(int brightenBy, Func func);
Func darkenBy(int brightenBy, Func func);
Func rgb_to_grey(Image<uint8_t> input);
void imwrite(std::string fname, int width, int height, Func continuation);

int main()
{
  std::string mStr;
  std::getline (std::cin,mStr);
  int m = atoi(mStr.c_str());

  std::string nStr;
  std::getline (std::cin,nStr);
  int n = atoi(nStr.c_str());

  Var x("x"), y("y"), c("c");

  Image<uint8_t> input = load_image("../images/maisie.png");
  Func inputImg("inputImg");
  inputImg = rgb_to_grey(input);

  Func img1Fun("img1Fun");
  img1Fun(x, y, c) = cast<uint16_t>(inputImg(x, y, c));

  Func img2Fun = brightenBy(m, img1Fun);
  Func img3Fun = darkenBy(n, img2Fun);

  /* cast back down to a uint8 image */
  Func outputFun("outputFun");
  outputFun(x, y, c) = cast<uint8_t>(img3Fun(x, y, c));

  imwrite("../images/prog4-out-halide.png",input.width(),input.height(), outputFun);
  return 0;
}
