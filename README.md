![argmax.ai](argmaxlogo.png)

*This repository is published and maintained by the Volkswagen Group Machine Learning Research Lab.*

*Learn more at https://argmax.ai.*


# Robust Quadrotor Frame for Machine Learning and Control Research

This repository contains the source code of mechanical parts used for the construction of a quadrotor frame suitable for machine learning and control research.
The requirements for such a frame are:

- Protect propellers and internal parts from crashes and drops from midair
- Possibility to mount sensors around the perimeter
- Easy to manufacture in-house
- Lightweight structure

This resulted in the following frame design.

![Quadrotor frame with printed parts][quadrotor]


## Materials and Manufacturing

All models for digital manufacturing can be compiled using the included makefile.
The program [openscad](https://openscad.org/) needs to be installed on the system.
The files are stored in the build folder after running the following command.

```bash
make -j
```

### 3D Printed Parts

The following parts should be printed in PLA on a 3D printer.

1x Holder for Battery             |  4x Mount for Motors
:--------------------------------:|:-------------------------:
![][batteryholder]                |  ![][motor]

24x Holder for Distance Sensors   |  1x Mount for Raspberry Pi
:--------------------------------:|:-------------------------:
![][laser]                        |  ![][raspberryholder]


### Laser Cut Parts

The following parts should be cut out of 2 mm thick polyamide with a laser cutter.

1x Drone Cage Top                 |  1x Drone Cage Bottom
:--------------------------------:|:-------------------------:
![][cagetop]                      |  ![][cagebottom]

4x Drone Cage Sides               |  4x Drone Cage Pillars
:--------------------------------:|:-------------------------:
![][cageside]                     |  ![][cagepillar]


[quadrotor]: build/main.png "Quadrotor frame with printed parts"
[batteryholder]: build/batteryholder.png "Part for holding the battery"
[motor]: build/motorholder.png "Quadrotor frame with printed parts"
[laser]: build/laser.png "Mount for laser sensor"
[raspberryholder]: build/raspberryholder.png "Mount for Raspberry Pi computer"
[cagetop]: build/cagetop.png "Cutting template for top of cage"
[cagebottom]: build/cagebottom.png "Cutting template for bottom of cage"
[cageside]: build/cageside.png "Cutting template for sides of cage"
[cagepillar]: build/cagepillar.png "Cutting template for cage pillars"


## Related Publications

If you find the code or models in this repository useful for your research, please consider citing our work.
The quadrotor frame described in this repository is used in the following [paper](https://arxiv.org/abs/2003.08876) and [dissertation](http://mediatum.ub.tum.de/1484075).

```BibTeX
@misc{beckerehmck2020learning,
  title={Learning to Fly via Deep Model-Based Reinforcement Learning}, 
  author={Philip Becker-Ehmck and Maximilian Karl and Jan Peters and Patrick van der Smagt},
  year={2020},
  eprint={2003.08876},
  archivePrefix={arXiv},
  primaryClass={cs.RO}
}
```

```BibTeX
@phdthesis {karl2020unsupervisedcontrol,
  author={Maximilian Karl},
  title={Unsupervised Control},
  type={Dissertation},
  school={Technische Universität München},
  address={München},
  year={2020}
}
```


## Disclaimer

The purpose of this source code is limited to bare demonstration of the experimental section of the related papers.
