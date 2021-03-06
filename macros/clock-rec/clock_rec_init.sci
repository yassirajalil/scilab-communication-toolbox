// Scilab Communication Toolbox
// (C) J.A. / contact: http://www.tsdconseil.fr 
//
// Ce logiciel est régi par la licence CeCILL-C soumise au droit français et
// respectant les principes de diffusion des logiciels libres. Vous pouvez
// utiliser, modifier et/ou redistribuer ce programme sous les conditions
// de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA 
// sur le site "http://www.cecill.info".
//
// En contrepartie de l'accessibilité au code source et des droits de copie,
// de modification et de redistribution accordés par cette licence, il n'est
// offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons,
// seule une responsabilité restreinte pèse sur l'auteur du programme,  le
// titulaire des droits patrimoniaux et les concédants successifs.
//
// A cet égard  l'attention de l'utilisateur est attirée sur les risques
// associés au chargement,  à l'utilisation,  à la modification et/ou au
// développement et à la reproduction du logiciel par l'utilisateur étant 
// donné sa spécificité de logiciel libre, qui peut le rendre complexe à 
// manipuler et qui le réserve donc à des développeurs et des professionnels
// avertis possédant  des  connaissances  informatiques approfondies.  Les
// utilisateurs sont donc invités à charger  et  tester  l'adéquation  du
// logiciel à leurs besoins dans des conditions permettant d'assurer la
// sécurité de leurs systèmes et ou de leurs données et, plus généralement, 
// à l'utiliser et l'exploiter dans les mêmes conditions de sécurité. 
//
// Le fait que vous puissiez accéder à cet en-tête signifie que vous avez 
// pris connaissance de la licence CeCILL-C, et que vous en avez accepté les
// termes.

function cr = clock_rec_init(osf,varargin)
// Creation of a clock recovery object.
// Calling Sequence
// cr = clock_rec_init(osf)
// cr = clock_rec_init(osf,ted,itrp,tc)
//
// Parameters
// osf: Input signal oversampling factor (e.g. ratio of input signal frequency vs symbol frequency)
// ted: Timing error detector object (default is Gardner detector). A ted can be created with the <link linkend="ted_init">ted_init</link> function.
// itrp: Interpolator object (default is cardinal cubic spline interpolator). A interpolator can be created with the <link linkend="itrp_init">itrp_init</link> function.
// tc: Time constant of the loop, in symbols (default is 5 symbols)
// cr: Resulting clock recovery object
//
// Description
// This function will create a clock recovery object, that can be used afterwards to resynchronize and resample an incoming NRZ stream with implicit clock.
//
// Optionnaly, the user can choose a specific Timing Error Detector (default is Gardner), and a specific interpolator (default is cardinal cubic spline). 
//
// <refsection><title>Example</title></refsection>
// <programlisting>
// // Create a clock recovery object for an oversampling ratio of 8
// cr = clock_rec_init(8);
// </programlisting>
//
// See also
//  clock_rec_process
//  ted_init
//  itrp_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    cr.phase = osf / 2;
    cr.osf   = osf;
    
    if(argn(2) == 1)
      cr.ted = ted_init();
    else
      cr.ted  = varargin(1);
    end;    
    if(argn(2) < 3)
      cr.itrp = itrp_init();
    else
      cr.itrp  = varargin(2);
    end;    
    
    cr.K2   = cr.ted.rythm;
    cr.tc   = 5;
    if(argn(2) >= 4)
      cr.tc = varargin(3);
    end;
    cr.cnt  = 0;
    // Sliding window for the interpolator
    cr.wnd_x = zeros(cr.itrp.nspl,1);
    // Sliding window for the TED
    cr.wnd_ted = zeros(cr.ted.nspl,1);
    // conversion tc en période d'échantillonnage
    //tc = cr.tc * osf;
    cr.gain = 1 - exp(-1/cr.tc);
    //cr.gain = osf * (1 - exp(-1/cr.tc));//0.25 * osf * (1 - exp(-1/cr.tc));
endfunction
