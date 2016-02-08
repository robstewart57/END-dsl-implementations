#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Image<uint8_t> blurX(Image<uint8_t> input);
Image<uint8_t> blurY(Image<uint8_t> input);
Image<uint8_t> brightenBy(Image<uint8_t> input, float);

int main()
{
  Image<uint8_t> img1 = load_image("../images/train.png");
  Image<uint8_t> img2 = blurX(img1);
  Image<uint8_t> img3 = blurY(img2);
  Image<uint8_t> img4 = brightenBy(img3, 1.5f);
  save_image(img4, "../images/prog3-out.png");
  return 0;
}
