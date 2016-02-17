#include "MidiFile.h"
#include "MidiEvent.h"
#include "Options.h"
#include "Halide.h"
using namespace Halide;
#include "halide_image_io.h"
using namespace Halide::Tools;

Func noFlats(Func music)
{
  Var x, y, c;
  Expr value = music(x, y, c);

  // E flat's to E's
  value = select ( 38 == value , 39 , value );
  value = select ( 50 == value , 51 , value );
  value = select ( 74 == value , 75 , value );
  value = select ( 86 == value , 87 , value );

  // B flat's to B's
  value = select ( 33 == value , 34 , value );
  value = select ( 45 == value , 46 , value );
  value = select ( 57 == value , 58 , value );
  value = select ( 69 == value , 70 , value );
  value = select ( 81 == value , 82 , value );

  // A flat's to A's
  value = select ( 31 == value , 32 , value );
  value = select ( 43 == value , 44 , value );
  value = select ( 55 == value , 56 , value );
  value = select ( 67 == value , 68 , value );
  value = select ( 79 == value , 80 , value );

  Func noFlats("noFlats");
  noFlats(x, y, c) = value;
  noFlats.vectorize(x, get_target_from_environment().natural_vector_size<uint16_t>());
  noFlats.compute_root();
  return noFlats;
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
      outputfile.addEvent(1, midiEvent.tick, midiEvent);
    }

  // write to a MIDI file the more spiriting version.
   outputfile.write("happy.mid");
 }
