#include "MidiFile.h"
#include "MidiEvent.h"
#include "Options.h"
#include <iostream>
#include <iomanip>
#include <sstream>
#include <iostream>

int main(int argc, char** argv)
{
   MidiFile outputfile;
   outputfile.absoluteTicks();
   outputfile.addTrack(1);
   int tpq = 800;
   outputfile.setTicksPerQuarterNote(tpq);

  Options options;
  options.process(argc, argv);  MidiFile midifile;
  if (options.getArgCount() > 0) {
    midifile.read(options.getArg(1));
  } else {
    midifile.read(cin);
  }

  int events = midifile[0].size();
  for (int event=0; event < events; event++)
    {
      MidiEvent midiEvent = midifile[0][event];

        // E flat:
        if ((int) midiEvent[1] == 38)
          midiEvent[1] = 39;

        if ((int) midiEvent[1] == 50)
          midiEvent[1] = 51;

        if ((int) midiEvent[1] == 74)
          midiEvent[1] = 75;

        if ((int) midiEvent[1] == 86)
          midiEvent[1] = 87;

        // B flat:
        if ((int) midiEvent[1] == 33)
          midiEvent[1] = 34;

        if ((int) midiEvent[1] == 45)
          midiEvent[1] = 46;

        if ((int) midiEvent[1] == 57)
          midiEvent[1] = 58;

        if ((int) midiEvent[1] == 69)
          midiEvent[1] = 70;

        if ((int) midiEvent[1] == 81)
          midiEvent[1] = 82;

        // A flat:
        if ((int) midiEvent[1] == 31)
          midiEvent[1] = 32;

        if ((int) midiEvent[1] == 43)
          midiEvent[1] = 44;

        if ((int) midiEvent[1] == 55)
          midiEvent[1] = 56;

        if ((int) midiEvent[1] == 67)
          midiEvent[1] = 68;

        if ((int) midiEvent[1] == 79)
          midiEvent[1] = 80;

      if (midiEvent[0] == 90) { midiEvent[1] = 1; }
      outputfile.addEvent(1, midiEvent.tick, midiEvent);
    }

   outputfile.write("happy.mid"); // write Standard MIDI File twinkle.mid
 }
