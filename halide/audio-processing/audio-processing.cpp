#include "MidiFile.h"
#include "MidiEvent.h"
#include "Options.h"
#include <iostream>
#include <iomanip>
#include <sstream>
#include <iostream>

#include <iostream>
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

#include <iomanip>
#include <iostream>
#include <random>
#include <string>
#include "Halide.h"

Func unflattenE(Func continuation)
{
  Func noFlat("noFlat");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = select ( 38 == value , 39 , value );
  value = select ( 50 == value , 51 , value );
  value = select ( 74 == value , 75 , value );
  value = select ( 86 == value , 87 , value );
  noFlat(x, y, c) = value;
  return noFlat;
}

Func unflattenB(Func continuation)
{
  Func noFlat("noFlat");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  value = select ( 33 == value , 34 , value );
  value = select ( 45 == value , 46 , value );
  value = select ( 57 == value , 58 , value );
  value = select ( 69 == value , 70 , value );
  value = select ( 81 == value , 82 , value );
  noFlat(x, y, c) = value;
  return noFlat;
}

Func unflattenA(Func continuation)
{
  Func noFlat("noFlat");
  Var x, y, c;
  Expr value = continuation(x, y, c);
  print(value);
  value = select ( 31 == value , 32 , value );
  value = select ( 43 == value , 44 , value );
  value = select ( 55 == value , 56 , value );
  value = select ( 67 == value , 68 , value );
  value = select ( 79 == value , 80 , value );
  noFlat(x, y, c) = value;
  return noFlat;
}

Func noFlats(Func music)
{
  Func noFlats("noFlats");
  Var x, y, c;
  Func noEFlat = unflattenE(music);
  Func noBFlat = unflattenB(noEFlat);
  Func noAFlat = unflattenA(noBFlat);
  return noAFlat;
}

int main(int argc, char** argv)
{
   MidiFile outputfile;
   outputfile.absoluteTicks();
   outputfile.addTrack(1);
   int tpq = 500;
   outputfile.setTicksPerQuarterNote(tpq);

   Options options;
   options.process(argc, argv);  MidiFile midifile;
   if (options.getArgCount() > 0) {
     midifile.read(options.getArg(1));
   } else {
     midifile.read(cin);
   }

   Var x, y, c;
   int width = midifile.getEventCount(0);
   int height = 1;

  int events = midifile[0].size();

  uint8_t arr[width];
  for (int event=0; event < events; event++)
    {
      MidiEvent midiEvent = midifile[0][event];
      uint8_t z = (uint8_t) midiEvent[1];
      arr[event] = z;
    }

  Buffer in_buff = Buffer(UInt(8), width, 1 , 1 , 0, arr);
  Image<uint8_t> image(in_buff);

  Func songFun("songFun");
  songFun(x, y, c) = cast<uint8_t>(image(x, y, c));
  Func songWithNoFlats = noFlats(songFun);

  Image<uint8_t> newImg(width, height, 1);
  songWithNoFlats.realize(newImg);

  buffer_t image_buffer =  *(newImg.raw_buffer());


  for (int event=0; event < events; event++)
    {
      MidiEvent midiEvent = midifile[0][event];
      midiEvent[1] = image_buffer.host[event];
      printf("was: %i, now: %i\n", midiEvent[1], image_buffer.host[event]);
      outputfile.addEvent(1, midiEvent.tick, midiEvent);

    }

   outputfile.write("happy.mid"); // write Standard MIDI File twinkle.mid
 }
