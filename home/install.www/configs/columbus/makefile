# This version of the makefile relies on gmake  (tm)
# 
#  Note the distinction between the COLD make variable and the
#  $COLUMBUS shell variable.  By default, the former is assigned to the
#  latter, and this requires that the environment variable (e.g. exported
#  variable) $COLUMBUS be defined as the directory that contains the
#  columbus shell scripts and executable files.  However, this definition
#  may be overridden in the make command line.  This is useful for
#  debugging, temporary reassignments, etc.  
#  e.g. %make COLD=a/b/c target
#  MMID=machineid is passed to gnumake 
#
######################### machine definition part ########################

#
#  use := assignment to enforce immediate expansion

COLD:=$(COLUMBUS)
MOLC:=$(MOLCAS)
MPI_LOADER=$$MPI_FC
INCFILE:=$(COLUMBUS)/machine.cfg/$(MMID)
$(warning INCFILE=$(INCFILE))
include $(INCFILE)

ifdef FORCESTATIC
 $(warning forcing statically linked binaries ...)
 ifndef STATIC
 $(error variable STATIC not defined in $(INCFILE))
 else
 LOADER+=$(STATIC)
 MPI_LOADER+=$(STATIC)
 $(warning new loader definition=$(LOADER) )
 endif
endif


RANL:=$(RANLIB)
LAP:=$(LAPACKLIBRARY)
BLAS:=$(BLASLIBRARY)
#LIBS:=$(COLD)/colib.a $(COLD)/libmolcas_col.a $(COLD)/blaswrapper.a $(MALIB) $(LAP) $(BLAS)
LIBS2:=$(COLD)/colib.a $(COLD)/libmolcas_col.a $(COLD)/blaswrapper.a $(LAP) $(BLAS)
LIBS:=$(COLD)/colib.a $(COLD)/blaswrapper.a $(LAP) $(BLAS)
CPP:=$(CPPL)
FSPLIT=$(COLD)/fsplit.pl

ifeq ( $(GACOMMUNICATION) , "TCGMSG" ) 
#PLIBS:=-L$(COLD) -lga -larmci -ltcgmsg -lma  
PLIBS:=$(COLD)/libga.a $(COLD)/libarmci.a $(COLD)/libtcgmsg.a $(COLD)/libma.a  
else
$(warning GAVERSION=$(GAVERSION):)
ifeq ("$(GAVERSION)","GA50") 
$(warning found equality)
PLIBS:=$(COLD)/libga50.a $(MPI_LIBS) 
else
#PLIBS=-L$(TACC_GA_LIB) -lga -larmci -lma  $(MPI_LIBS)
PLIBS:=$(TACC_GA_LIB)/libga.a $(TACC_GA_LIB)/libarmci.a $(TACC_GA_LIB)/libga.a 
# no should also do
#PLIBS:=$(TACC_GA_LIB)/libga.a $(COLD)/libarmci.a $(COLD)/libtcgmsg-mpi.a  $(COLD)/libma.a  $(MPI_LIBS) 
endif
endif
$(warning PMAKE= $(PMAKE))
ifeq ($(PMAKE),yes) 
DKEYWORDSLOCAL:=$(DKEYWORDS) $(DPARALLELKEYS)
CPPDIRLOCAL:=$(CPPDIR) $(DPARALLELKEYS)
$(warning setting DKEYWORDSLOCAL 1  to $(DKEYWORDSLOCAL))
$(warning setting CPPDIRLOCAL 1  to $(CPPDIRLOCAL))
else
DKEYWORDSLOCAL:=$(DKEYWORDS)
CPPDIRLOCAL:=$(CPPDIR)
$(warning setting DKEYWORDSLOCAL 2  to $(DKEYWORDSLOCAL))
$(warning setting CPPDIRLOCAL 2  to $(CPPDIRLOCAL))
endif

ifdef MOLC
HM=$$LIBMOLCAS
DKEYWORDSLOCAL:=$(DKEYWORDSLOCAL) $(DMOLCASKEYS)
$(warning setting DKEYWORDSLOCAL 3  to $(DKEYWORDSLOCAL))
$(warning LIBMOLCAS set to $(HM)) 
endif 

$(warning PLIBS=$(PLIBS))

ifeq ( $(MMID), "sun" ) 
PLIBS+= -lsocket -lrpcsvc -lnsl
endif
$(warning setting PLIBS to $(PLIBS))
$(warning setting LIBS to $(LIBS))
$(warning setting LIBS2 to $(LIBS2))


.SUFFIXES:
.SUFFIXES:	.x .o .f .c .F .f90 .F90 

.o.x:		# default loader.
	$(LOADER) -o $@ $*.o $(LIBS)
.f.o:		#default fortran compilation:
	$(FORTRAN) $(FIXED) $(FFLAGS) $<
.c.o:  
	$(CC) $< 

$(warning cpp WITH_REDIRECTON  :$(WITH_REDIRECTION):  )
.F.f:
	$(CPP)  $(CFLAGS) $(CPPDIRLOCAL) $(WITH_REDIRECTION) $< | sed '/^#/D' > $*.f 
.F.o:
	$(CPP)  $(CFLAGS) $(CPPDIRLOCAL) $(WITH_REDIRECTION) $< | sed '/^#/D' > $*.f 
	$(FORTRAN) $(FIXED) $(FFLAGS) $*.f 
.f90.o:
	$(FORTRAN) $(FREE) $(FFLAGS) $<
.F90.o:
	$(FORTRAN) $(FREE) $(DKEYWORDSLOCAL) $(FFLAGS) $<

# some versions of make cannot put the above two rules together, so this
# explicit rule should be the same as the combination of the above rules.
.f.x:		#default compile and load for single-file programs:
	$(FORTRAN) $(FIXED) $(FFLAGS) $<
	$(LOADER) -o $@ $*.o $(LIBS)



###########Files to be compiled with a different optimization level ###########
# they are listed in the machine specific machine.cfg/* files 

$(OBJECTSCARE): %.o: %.f
	$(FORTRAN) $(FIXED) $(FFLAGSCARE) $< 
$(OBJECTS2): %.o: %.f
	$(FORTRAN) $(FIXED) $(FFLAGS2) $< 
$(OBJECTS2FREE): %.o: %.F90
	$(FORTRAN) $(FREE) $(DKEYWORDSLOCAL)  $(FFLAGS2) $< 
$(OBJECTSCAREFREE): %.o: %.F90
	$(FORTRAN) $(FREE) $(DKEYWORDSLOCAL)  $(FFLAGSCARE) $< 

#################################################
# clean up working directories. leave only .f sources.
clean:
	rm -f *.x *.o *~ cmdcin cmdcls *.l

################# dalton section ##################
ABACUSOBJS=abaopt.o dalton.o her1ave.o her1car.o her1drv.o her1int.o \
           her1odc.o her1out.o her1pro.o her1sym.o her2ave.o her2dir.o \
           her2drv.o her2el1.o her2el2.o her2fck.o her2her.o her2odc.o \
           her2out.o her2sup.o her2sym.o herbas.o herdirect.o herdrv.o \
           hergam.o hergeo.o herrdn.o hersol.o hersym.o hertst.o \
           huckel.o wrtsif.o hergp.o aba2tex.o abaaat.o abacc.o \
           abacol.o abadip.o abadrv.o           abaedrv.o \
           abaexc.o abaflt.o          abalnr.o abalrs.o           \
           abamag.o abanuc.o          abaort.o abaptr.o          \
           abarhs.o abarlx.o abaset.o abatro.o abavib.o abawalk.o \
           abasir.o rspdm.o csfstuff.o detfi.o cioff.o dets0.o \
           cisig.o dets1.o dens.o
ERIOBJS=eri2aob.o eri2car1.o eri2car2.o eri2cft.o eri2dis.o \
         eri2sym.o eri2vec.o eri2drv.o eri2fck.o eri2her.o eri2odb.o \
         eri2out.o eri2sph.o

#GPSINGLE=arhpack.o dge.o dsp.o fastio_g07.o gphjj.o gpjeppe.o gptrygve.o graphic.o linextra.o mempkg.o printpkg.o qpack.o 
# fastio_g07 function names collide with molcas I/O library 
GPSINGLE=arhpack.o dge.o dsp.o gphjj.o gpjeppe.o gptrygve.o graphic.o linextra.o mempkg.o printpkg.o qpack.o 
ifeq ( $(MMID), "cray" ) 
GPSINGLE+=vcraypack.o
endif

gp.a: $(GPSINGLE) $(SBLAS) 
	$(AR) gp.a $(GPSINGLE) $(SBLAS)
	$(RANL) gp.a
	cp gp.a $(COLD)

dalton.x: gp.a $(ABACUSOBJS) $(ERIOBJS) 
	$(LOADER) -o $@ *.o gp.a $(LIBS2)  

pdalton.x: paralib.o  gp.a $(ABACUSOBJS) $(ERIOBJS)  
	$(MPI_LOADER) -o $@  $(ABACUSOBJS) $(ERIOBJS) gp.a paralib.o  $(PLIBS) $(LIBS) $(MALIB)

####################cosmolib section ##########################

COSMO=dalton.o her1car.o her1drv.o her1int.o her1odc.o her1out.o her1pro.o her1sym.o herbas.o herdrv.o hergam.o hergp.o herrdn.o \
      hersol.o hersym.o huckel.o wrtsif.o
CGRAD=ansude.o consts.o  cosgrddim.o  cosmo.o  outcorr.o  writecosmo.o  coschol1.o  cosgrdinit.o  cosmoinit.o  dvfill.o readinp.o testgrad.o \
      writsude.o cavitygrd.o  coschol2.o  basgrdinit.o  irreducible.o  replicate.o 

cosmolib.a: $(COSMO) $(CGRAD) 
	$(AR) cosmolib.a $(COSMO) $(CGRAD)
	$(RANL) cosmolib.a 
	cp cosmolib.a $(COLD)

potential.x: potentialmodfree.o potenrg.o 
	$(LOADER) -o $@  potentialmodfree.o potenrg.o  $(LIBS)
# chelpg for Columbus
chelpg_col.x: chelpg_col.o potsub.o her1car.o her1odc.o her1sym.o herdrv.o herrdn.o hersym.o utils.o basout.o 
	$(LOADER) -o $@  chelpg_col.o potsub.o her1car.o her1odc.o her1sym.o herdrv.o herrdn.o hersym.o utils.o basout.o $(DALTON_DIR)/gp.a $(LIBS)



#################################################
CMDCOBS=cmdc.o colib6.o colib7.o
colib6.f colib7.f :		# if necessary, copy the library files
	cp $(COLD)/source/colib/$@ .
cmdc.x: $(CMDCOBS)
	$(CDEF) $(KOPC)
	$(LOADER) $(STATIC) -o $@ *.o 
#################################################
COLIBROOT=colib1.f colib2.f colib3.f colib4.f colib5.f colib6.f colib7.f colib8.f colib9.f colib10.f colib8a.f 
COLIBFORS=$(COLIBROOT)

SHELL=/bin/sh
colib.a: $(COLIBFORS) $(KOPC) $(KOPF) 
	$(FORTRAN) $(FIXED) $(FFLAGS) $(COLIBFORS)
	$(CDEF) $(KOPC) 
	$(AR) colib.a *.o 
	$(RANL) colib.a  
	$(FORTRAN) $(FIXED) $(FFLAGS) testcod34x.f
	$(LOADER) -o testcod34x.x testcod34x.o colib.a $(COLD)/blaswrapper.a $(BLASLIBRARY)
	echo "34-ext integral header checks by COLUMBUS/source/colib/testcod34x.x"

#################################################
mmulb.x: mmulb.o colib1.o  #for benchmarking and tuning matrix routines.
	$(LOADER) -o $@ mmulb.o colib1.o $(LIBS)
#################################################
ARGOSFOR=argos1.f argos2.f argos3.f argos4.f argos5.f argos6.f
ARGOSOBS=argos1.o argos2.o argos3.o argos4.o argos5.o argos6.o
ifeq ( $(MMID), "cray" ) 
argos6.o: argos6.f		# enable real*16 arithmetic
	$(FORTRAN) $(FIXED) -ep -ei -O3 $<  
endif
ifeq ( $(MMID), "cray" ) 
argos6.o: argos6.f		# enable real*16 arithmetic
	$(FORTRAN) $(FIXED) -O3 -Onofastint $<  
argos6.o: argos6.f		# enable real*16 arithmetic
endif

argos.x: $(ARGOSOBS)
	$(LOADER) -o $@ $(ARGOSOBS) $(LIBS)
#################################################
CNVRTOBS=cnvrt.o 
cnvrt.x: $(CNVRTOBS)
	$(LOADER) -o $@ $(CNVRTOBS) $(LIBS)
#################################################
SCFPQOBS=scfpq1.o scfpq2.o 
scfpq.x: $(SCFPQOBS)
	$(LOADER) -o $@ $(SCFPQOBS) $(COLD)/gp.a $(LIBDALTON2)  $(LIBS2) $(MALIB)
#################################################
MCDRTOBS=mcdrt1.o mcdrt2.o
mcdrt.x: $(MCDRTOBS)
	$(LOADER) -o $@ $(MCDRTOBS) $(LIBS)
#################################################
MCSCFOBS=paralib.o molcaswrapper.o tranlib.o mcscf1.o mcscf2.o mcscf3.o mcscf4.o mcscf5.o  \
	mcscf7.o mcscf8.o mcscf9.o mcscf10.o 
mcscf.x: $(MCSCFOBS)
	$(LOADER) -o $@ $(MCSCFOBS)  $(COLD)/cosmolib.a  $(COLD)/gp.a $(LIBDALTON2) $(LIBS2) $(MALIB)
pmcscf.x:$(MCSCFOBS) 
	$(MPI_LOADER) -o $@ $(MCSCFOBS)  $(COLD)/cosmolib.a  $(COLD)/gp.a  $(LIBDALTON2) $(PLIBS)  $(LAP) $(LIBS2) $(MALIB)
#################################################
CIDRTOBS=cidrt_data.o cidrt1.o cidrt2.o cidrt3.o cidrt4.o 
REINDEX=reindex_data.o reindex.o
cidrt.x: $(CIDRTOBS) $(REINDEX)
	$(LOADER) -o cidrt.x $(CIDRTOBS) $(LIBS)
	$(LOADER) -o reindex.x $(REINDEX) $(LIBS) 
cidrt_d.x: $(CIDRTOBS)
	$(LOADER) -o $@ $(CIDRTOBS) $(LIBS)
#################################################
CIDRTMSOBS=cidrtms1.o cidrtms2.o cidrtms3.o cidrtms4.o
cidrtms.x: $(CIDRTMSOBS)
	$(LOADER) -o $@ $(CIDRTMSOBS) $(LIBS)
#################################################
CIUFTOBS=ciuft1.o ciuft2.o
ciuft.x: $(CIUFTOBS)
	$(LOADER) -o $@ $(CIUFTOBS) $(LIBS)
#################################################
CISRTOBS=cisrt1.o cisrt2.o cisrt3.o
CNVRTOBS=cnvrt.o
SCFPQOBS=scfpq1.o scfpq2.o 
TRANOBS=tran1.o tran2.o tran3.o tran4.o tran5.o  tran6.o tran7.o tran8.o tran9.o
cisrt.x: $(CISRTOBS)
	$(LOADER) -o $@ $(CISRTOBS) $(LIBS)
#
#   no MOLCASOBS should refer to a blas library routine if an integer size argument mismatch may arise!
#   see testcode in colib
#

MOLCASOBS65=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o remdmp.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysinf.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o int2real.o loadints.o allocramd.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o prgminitf.o prgminit.o mystring.o get_progname.o

MOLCASOBS64=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o remdmp.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysinf.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o allocramd.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o ftranslate.o 

MOLCASOBS70P266=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o remdmp.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysinf.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o ftranslate.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o mchprm.o popcorn.o dumpja.o getrec.o ip_of_iwork.o getstf.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o 

MOLCASOBS72P40=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o

MOLCASOBS73P306=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o put_iscalar.o genint.o 

MOLCASOBS75P560=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o put_iscalar.o genint.o \
   warningmessage.o get_larray.o log2int.o 
MOLCASOBS77P49=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o extract.o cextract.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o put_iscalar.o genint.o \
   warningmessage.o get_larray.o log2int.o gzrdrun.o gzwrrun.o blas_wrappers.o c2r8.o ldf_setinc.o covradt_init.o

MOLCASOBS77P506=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o xml_close.o xml_closec.o poke_iscalar.o  \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o allocmem.o sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o put_iscalar.o genint.o \
   warningmessage.o get_larray.o log2int.o gzrdrun.o gzwrrun.o blas_wrappers.o c2r8.o ldf_setinc.o covradt_init.o

MOLCASOBS79P111=abend.o aixcls.o aixerr.o aixopn.o aixrd.o aixwr.o allocdisk.o cdafile.o cio.o crdrun.o cxrdrun.o \
          daclos.o daname_mf.o daname.o ddafile.o drdrun.o dxrdrun.o fastio.o fioinit.o get_dscalar.o getenvc.o \
          getenvf.o gxrdrun.o icloc.o idafile_.o idafile.o inique.o inquire.o irdrun.o isfreeunit.o ixrdrun.o \
          king.o mkrun.o mpdafile.o namerun.o opnrun.o qenter.o qexit.o qtrace.o stdfmt.o strnln.o ffrun.o ffxrun.o \
          sysexpand.o sysmessages.o sysputs.o systemc.o systemf.o timingc.o upcase.o wr_motra_info.o xquit.o xflush.o \
          daname_main.o iprintlevel.o hbomb.o get_iscalar.o get_iarray.o get_carray.o dmpone.o opnone.o clsone.o opnord.o getord.o \
          int2real.o loadints.o ip_of_work.o xml_close.o xml_closec.o poke_iscalar.o  \
          rdord.o  ordin1.o ordin2.o rdord_.o upkr8.o tcd_r8.o rld_r8.o one_ulp.o init_getint.o decideoncholesky.o getint.o daname_mf_wa.o rdchovec.o \
          get_darray.o get_progname.o quit.o prgminitf.o prgminit.o mystring.o \
          put_darray.o cwrrun.o iwrrun.o dwrrun.o cxwrrun.o dxwrrun.o ixwrrun.o gxwrrun.o so2ci.o nr_shells.o \
          setup_ints.o getmem.o inimem.o  sofsh1.o statp.o setmem_ints.o inisew.o clssew.o xrlsmem_ints.o seward_init.o getinf.o ip_of_iwork.o setup_isd.o \
          iiloc.o idloc.o illoc.o get_info_static.o get_info_dynamic.o qpg_darray.o make_labels.o sphere.o setup_rw.o flip_flop.o \
          term_ints.o free_rctfld.o free_isd.o freek2.o closer.o rlsmem_ints.o set_binom.o set_canind.o set_basis_mode.o mk_triind.o \
           dcr.o def_shells.o allocate_iwork.o free_iwork.o gen_relpointers.o errtra.o sether.o setupr.o tstfnc.o intrea.o triprt.o install_ab.o readab.o install_rw.o banner.o recprt.o molcas_open.o pfget.o iprmt.o molcas_open_ext.o  put_carray.o put_cmo.o put_dscalar.o gamod.o put_iscalar.o genint.o \
   warningmessage.o get_larray.o log2int.o gzrdrun.o gzwrrun.o blas_wrappers.o c2r8.o ldf_setinc.o covradt_init.o get_int.o cgetshmem.o cgetmem.o




rdonexx.o: rdonexx.F 
	$(FORTRAN) $(FIXED) $(MOLCASFF) rdonexx.F 
genint.o : genint.F  
	$(FORTRAN) $(FIXED) $(MOLCASFF) genint.F  
getmolcasinfo.o: getmolcasinfo.f
	$(FORTRAN) $(FIXED) $(MOLCASFF) getmolcasinfo.f
getrunfileinfo.o: getrunfileinfo.f
	$(FORTRAN) $(FIXED) $(MOLCASFF) getrunfileinfo.f

molcas.x: $(TRANOBS)  getmolcasinfo.o rdonexx.o genint.o link_it.o mofmt.o 
	$(ARX) $$LIBMOLCAS $(MOLCASOBS)
	$(AR) libmolcas_col.a $(MOLCASOBS)
	$(RANLIB) libmolcas_col.a
	rm -f $(MOLCASOBS)
	$(LOADER) -static -o getmolcasinfo.x getmolcasinfo.o libmolcas_col.a
	$(LOADER) -static -o tran_molcas.x  $(TRANOBS) rdonexx.o genint.o link_it.o libmolcas_col.a $(COLD)/cosmolib.a $(COLD)/gp.a $(LIBS)
#cp getmolcasinfo.x $(COLD)

#
#  libmolcas_col.a includes either just the wrapper library
#  or interface and selected molcas objects from libmolcas.a
#
molcas.a:molcaswrapper.o dalton2wrapper.o molcasstub.o getrunfileinfo.o getmolcasinfo.o 
	$(ARX) $$LIBMOLCAS $(MOLCASOBS)
	$(AR) libmolcas_col.a $(MOLCASOBS) molcaswrapper.o dalton2wrapper.o
	$(AR) libmolcas_col2.a $(MOLCASOBS) molcasstub.o
	$(RANLIB) libmolcas_col.a
	$(RANLIB) libmolcas_col2.a
	rm -f $(MOLCASOBS)
	cp libmolcas_col.a $(COLD)
	cp libmolcas_col2.a $(COLD)
	$(LOADER) -o getrunfileinfo.x getrunfileinfo.o  $(COLD)/libmolcas_col.a $(LIBS) $(MALIB) 
	$(LOADER) -o getmolcasinfo.x getmolcasinfo.o  $(COLD)/libmolcas_col.a $(LIBS) $(MALIB) 

molcaswrapper.a:molcaswrapper.o dalton2wrapper.o molcasstub.o
	$(AR) libmolcas_col.a molcaswrapper.o dalton2wrapper.o
	$(AR) libmolcas_col2.a molcasstub.o 
	$(RANLIB) libmolcas_col.a
	$(RANLIB) libmolcas_col2.a
	cp libmolcas_col.a $(COLD)
	cp libmolcas_col2.a $(COLD)

       
##################dalton2####################################
DALTON2F=readt.F fndlb2.F flshfo.F  gpclose.F  gpopen.F  izero.F  mollab.F  opendx.F  quit.F  timtxt.F  trace.F  tstamp.F  
libdalton2.a:$(DALTON2F) getproperty.o getdalton1.o
	rm -f libdalton2.F libdalton2.f
	cat $(DALTON2F) > libdalton2.F
	$(CPP) $(DALTON2CPP) -I./  $(WITH_REDIRECTION) libdalton2.F | sed '/^#/D' >> libdalton2.f
	$(FORTRAN) $(FIXED) $(FFLAGS) libdalton2.f getdalton1.f getproperty.f 
	$(AR) libdalton2.a libdalton2.o getdalton1.o getproperty.o 
	cp libdalton2.a $(COLD)
 
#################################################
TRANOBS=tran1.o tran2.o tran3.o tran4.o tran5.o  tran6.o tran7.o tran8.o tran9.o
#tranold.x.: $(TRANOBS)
#$(LOADER) -o $@ $(TRANOBS) $(COLD)/gp.a  $(LIBDALTON2) $(LIBS2) $(MALIB) 
TRANNEW=molcaswrapper.o tran_data.o tran_io.o tran_math.o tran_utils.o tran_sort.o tran_trafo.o tran_main.o tran.o
tran.x:$(TRANNEW) 
	$(LOADER) -o $@ $(TRANNEW) $(COLD)/gp.a $(LIBDALTON2) $(LIBS) $(COLD)/libmolcas_col2.a $(LIBS) $(MALIB)
#$(LOADER) -o tranold.x $(TRANOBS) $(COLD)/gp.a  $(LIBDALTON2) $(LIBS2) $(MALIB) 
#################################################
CIUDGOBS1=ciudg_data.o molcaswrapper.o ciudg_matutil.o ciudg_gautil.o ciudg_ioutil.o ciudg_drtutil.o ciudg_utils.o ciudg_loop.o ciudg_setup.o maksortmod.o cisrtmod.o  
CIUDGOBS2=ciudg_diag.o ciudg_allin.o  ciudg_fourex_mod.o ciudg_threx.o ciudg_twoext.o ciudg_onext.o ciudg_allin.o ciudg_diag.o ciudg_spinorbit.o
#CIUDGOBS2=ciudg_diag.o ciudg_allin.o ciudg_cosmo.o ciudg_fourex_mod.o ciudg_threx.o ciudg_twoext.o ciudg_onext.o ciudg_allin.o ciudg_diag.o ciudg_spinorbit.o
CIUDGOBS3=ciudg_oneden.o ciudg_twoden.o ciudg_main.o drivercid.o driver.o driversize.o driverwrap.o ciudg.o
CIUDGFOR1=molcaswrapper.F90 ciudg_data.F90 ciudg_matutil.F90 ciudg_gautil.F90 ciudg_ioutil.F90 ciudg_drtutil.F90 ciudg_utils.F90 ciudg_loop.F90 ciudg_setup.F90 maksortmod.F90 cisrtmod.F90  
CIUDGFOR2=ciudg_diag.F90 ciudg_allin.F90 ciudg_fourex_mod.F90 ciudg_threx.F90 ciudg_twoext.F90 ciudg_onext.F90 ciudg_allin.F90 ciudg_diag.F90 ciudg_spinorbit.F90
#CIUDGFOR2=ciudg_diag.F90 ciudg_allin.F90 ciudg_cosmo.F90 ciudg_fourex_mod.F90 ciudg_threx.F90 ciudg_twoext.F90 ciudg_onext.F90 ciudg_allin.F90 ciudg_diag.F90 ciudg_spinorbit.F90
CIUDGFOR3=ciudg_oneden.F90 ciudg_twoden.F90 ciudg_main.F90 drivercid.F90 driver.F90 driversize.F90 driverwrap.F90 ciudg.F90
ciudg.x: $(CIUDGOBS1) $(CIUDGOBS2) $(CIUDGOBS3)  
	$(LOADER) -o $@ $(CIUDGOBS1) $(CIUDGOBS2) $(CIUDGOBS3)  $(COLD)/gp.a $(LIBDALTON2)  $(LAP) $(LIBS2) $(MALIB)
pciudg.x: $(CIUDGOBS1) $(CIUDGOBS2) $(CIUDGOBS3)
	$(MPI_LOADER) -o $@ $(CIUDGOBS1) $(CIUDGOBS2) $(CIUDGOBS3)  $(LIBDALTON2) $(PLIBS)  $(LAP) $(LIBS2) $(MALIB)
#	$$MPI_FC -o $@ $(CIUDGOBS1) $(CIUDGOBS2) $(CIUDGOBS3) $(COLD)/cosmolib.a $(COLD)/gp.a $(LIBDALTON2) $(PLIBS)  $(LAP) $(LIBS2) $(MALIB)

##################################################################################
CIMKSEG =cimkseg1.o cimkseg2.o cimkseg3.o cimkseg9.o cimkseg12.o \
         cimkseg4.o cimkseg5.o cimkseg6.o cimkseg7.o cimkseg10.o cimkseg14.o
cimkseg.x: $(CIMKSEG) 
	$(LOADER) -o $@ $(CIMKSEG)  $(LAP) $(LIBS)

##############################################################
PCIDENOBS=pciden1.o pciden2.o pciden3.o pciden4.o pciden5.o \
          pciden6.o pciden7.o pciden8.o pciden9.o pciden10.o pciden11.o \
          pciden12.o pciden13.o 

pciden.x: $(PCIDENOBS)
	$(MPI_LOADER) -o $@ $(PCIDENOBS) $(PLIBS) $(LIBS)

##############################################################
CIPCOBS=cipc1.o cipc2.o cipc3.o
cipc.x: $(CIPCOBS)
	$(LOADER) -o $@ $(CIPCOBS) $(LIBS)
mcpc.x: mcpc1.o mcpc2.o 
	$(LOADER) -o $@ mcpc1.o mcpc2.o  $(LIBS)
######################################################################
CIDENOBS=ciden1.o ciden2.o ciden3.o ciden4.o ciden5.o \
	ciden6.o ciden7.o ciden8.o ciden9.o ciden10.o ciden11.o ciden12.o 
CIDENFOR=ciden1.f ciden2.f ciden3.f ciden4.f ciden5.f \
	ciden6.f ciden7.f ciden8.f ciden9.f ciden10.f ciden11.f ciden12.f 
ciden.x: $(CIDENOBS)
	$(LOADER) -o $@ $(CIDENOBS) $(LIBS)

ciden.old.x: ciden1.o ciden2.o ciden3.o ciden4.o ciden5.o ciden6.o ciden7.o \
             ciden8.o ciden9.o ciden10.o 
	$(LOADER) -o $@ *.o $(LIBS)

#################################################
CIGRDOBS=paralib.o cigrd1.o cigrd2.o cigrd3.o cigrd4.o cigrd5.o \
	cigrd6.o cigrd7.o cigrd8.o cigrd9.o
CIGRDFOR=cigrd1.f cigrd2.f cigrd3.f cigrd4.f cigrd5.f \
        cigrd6.f cigrd7.f cigrd8.f cigrd9.f
pcigrd.x: $(CIGRDOBS)
	$(MPI_LOADER) -o $@ $(CIGRDOBS) $(PLIBS) $(LIBS) $(MALIB)
cigrd.x: $(CIGRDOBS)
	$(LOADER) -o $@ $(CIGRDOBS) $(LIBS) $(MALIB)
#################################################
BATRAOBS=batra1.o batra2.o batra3.o
batra.x: $(BATRAOBS)
	$(LOADER) -o $@ $(BATRAOBS) $(LIBS)
#################################################
sif.x: mofmt.o icheck.o ifake.o irfmt.o iwfmt.o istat.o istatmo.o 
	$(LOADER) -o icheck.x icheck.o $(LIBS)
	$(LOADER) -o ifake.x  ifake.o  $(LIBS)
	$(LOADER) -o irfmt.x  irfmt.o  $(LIBS)
	$(LOADER) -o iwfmt.x  iwfmt.o  $(LIBS)
	$(LOADER) -o istat.x  istat.o  $(LIBS)
	$(LOADER) -o istatmo.x  istatmo.o  $(LIBS)
	$(LOADER) -o mofmt.x  mofmt.o  $(LIBS2) $(MALIB)
##################################################
INTCOBJS=intc1.o intc2.o intc3.o intc4.o intc5.o intc6.o
intc.x: $(INTCOBJS)
	$(LOADER) -o intc.x $(INTCOBJS) $(LIBS)
#################################################
##################################################
get.x:  unik.gets.o argnew.o hernew.o 
	$(LOADER) -o argnew.x argnew.o $(LIBS) 
	$(LOADER) -o hernew.x hernew.o $(LIBS)
	$(LOADER) -o unik.gets.x unik.gets.o $(LIBS)
#################################################
mak.x: makscf.o makintc.o 
	$(LOADER) -o makscf.x makscf.o  $(LIBS)
	$(LOADER) -o makintc.x makintc.o  $(LIBS)
#################################################
MAKPCIUDGOBS= makpciudg1.o makpciudg2.o 
makpciudg.x: $(MAKPCIUDGOBS)
	$(LOADER) -o makpciudg.x $(MAKPCIUDGOBS) $(LIBS) 
#################################################
utils.x: shavitt.o densav.o makeryd.o reordermo.o mo_mult.o mo_convert.o cutci.o phaseci.o slope.o xyz2col.o tm2col.o col2tm.o liic.o liicm.o disp_normcoord.o symmconv.o 
	$(LOADER) -o densav.x densav.o $(LAP) $(LIBS)
	$(LOADER) -o makeryd.x makeryd.o $(LIBS)
	$(LOADER) -o reordermo.x reordermo.o $(LIBS)
	$(LOADER) -o mo_mult.x mo_mult.o $(LIBS2) $(MALIB)
	$(LOADER) -o mo_convert.x mo_convert.o $(LIBS2) $(MALIB)
	$(LOADER) -o phaseci.x phaseci.o $(LIBS)
	$(LOADER) -o slope.x slope.o $(LIBS)
	$(LOADER) -o xyz2col.x xyz2col.o $(LIBS)
	$(LOADER) -o tm2col.x tm2col.o $(LIBS)
	$(LOADER) -o col2tm.x col2tm.o $(LIBS)
	$(LOADER) -o liic.x liic.o $(LIBS)
	$(LOADER) -o liicm.x liicm.o $(LIBS)
	$(LOADER) -o shavitt.x shavitt.o $(LIBS)
	$(LOADER) -o symmconv.x symmconv.o $(LIBS)
	$(LOADER) -o disp_normcoord.x disp_normcoord.o $(LIBS)
cutci.o:cutci1.o cutci2.o
	$(LOADER) -o cutci.x cutci1.o cutci2.o $(LIBS)
	$(FORTRAN) $(FREE) $(FFLAGS) mkciovinp.f90
	$(LOADER) -o mkciovinp.x mkciovinp.o $(LIBS2) $(MALIB)
#################################################
 iargos.x: iargos1.f iargos2.f 
	$(FORTRAN) $(FIXED) $(FFLAGSCARE) iargos1.f iargos2.f 
	$(LOADER) -o iargos.x iargos1.o iargos2.o   $(LIBS)  
##############################################
trci2den.x: trci2den.o
	  $(LOADER) -o $@ trci2den.o $(LIBS)
##############################################
FFOBS= ffield.o
ffield.x: $(FFOBS) 
	  $(LOADER) -o $@ $(FFOBS) $(LIBS)
#################################################
#EXPTVLOBS=exptvl1.o exptvl2.o pipek_mezey.o
EXPTVLOBS=exptvl_data.o exptvl1.o exptvl2.o pipek_mezey.o 
exptvl.x: $(EXPTVLOBS)
	  $(LOADER) -o $@ $(EXPTVLOBS) $(LIBS2) $(MALIB)
#################################################
gdiis.x: gdiis.o givens.o
	 $(LOADER) -o gdiis.x gdiis.o givens.o $(LAP) $(LIBS) 
#################################################
suscal.x: suscal.o
	$(LOADER) -o suscal.x suscal.o $(LIBS) 
#################################################
dzero.x: dzero.o
	$(LOADER) -o $@ dzero.o $(LIBS)
#################################################
sumcivec.x: sumcivec.o
	$(LOADER) -o $@ sumcivec.o $(LIBS)
#################################################
cart2int.x: cart2int.o
	$(LOADER) -o cart2int.x cart2int.o $(LIBS)
#################################################
transci.x: transci.o
	$(LOADER) -o transci.x transci.o $(LIBS2) $(MALIB)
#################################################
rgf.x: rgf1.f rgf2.f
	$(FORTRAN) $(FIXED) $(FFLAGSCARE) rgf1.f rgf2.f  
	$(LOADER) -o rgf.x rgf1.o rgf2.o $(LIBS)  
################################################
TRAN2XOBS=tran2x1.o tran2x2.o tran2x3.o tran2x4.o tran2x5.o \
       	  tran2x6.o tran2x7.o tran2x8.o tran2x9.o
tran2x.x: $(TRAN2XOBS)
	  $(LOADER) -o $@ $(TRAN2XOBS) $(LIBS)
#################################################
CISRT2XOBS=cisrt2x1.o cisrt2x2.o cisrt2x3.o
cisrt2x.x:$(CISRT2XOBS)
	  $(LOADER) -o $@ $(CISRT2XOBS) $(LIBS)
#################################################
TRANSMOMOBS=transmom1.o transmom2.o transmom3.o transmom4.o
TRANSMOMFOR=transmom1.f transmom2.f transmom3.f transmom4.f

transmom.x: $(TRANSMOMOBS)
	$(LOADER) -o $@ $(TRANSMOMOBS) $(LIBS)

##################################################################
transft.x:transft.o
	$(LOADER) -o $@ transft.o $(LIBS)
##################################################################
transmo.x:transmo.o
	$(LOADER) -o $@ transmo.o $(COLD)/libmolcas_col.a $(LAP) $(LIBS) $(MALIB)
#################################################################
POLYHESOBS=polyhes.o utilities.o
polyhes.x:$(POLYHESOBS)
	$(LOADER) -o $@ $(POLYHESOBS)
######################################################################
CONTSROBS=constraint.o ../polyhes/utilities.o
constraint.x:$(CONTSROBS)
	$(LOADER) -o $@ $(CONTSROBS) $(LIBS)
######################################################################
lvalue.x:lvalue.o
	$(LOADER) -o $@ lvalue.o $(LAP) $(LIBS)

testblas.x:testblas.o
	$(LOADER) -o $@ testblas.o $(BLASLIBRARY)

blaswrapper.a:blaswrapper.o testblas.x
	$(AR) blaswrapper.a blaswrapper.o 
	$(RANL) blaswrapper.a
	cp blaswrapper.a $(COLD)

######################## GCF ######################

GCFFOR=columbus_precision_defs.F90 precision_defs.F90 drt_util_mod.F90 bummer_mod.F90 symmetry_mod.F90 mcdrt_mod.F90 gcf_mod.F90 praxis.F segment_mod.F90 \
       io_units_mod.F90 arc_mod.F90 hmat_data_mod.F90 mo_sort_mod.F90 g_level_mod.F90 tr_newton_mod.F90 hmat_mod.F90 cg_descent.F90 \
       brent_fmin_mod.F90 lbfgs.F diis_mod.F90 exponential_extrap_mod.F90 timer_mod.F90 alloc_data_mod.F90 arc_opt_mod.F90 \
       gcf_egh_mod.F90 hmat_util_mod.F90 gcfci.F90
GCFOBS=precision_defs.o drt_util_mod.o bummer_mod.o symmetry_mod.o mcdrt_mod.o gcf_mod.o praxis.o segment_mod.o \
       io_units_mod.o arc_mod.o hmat_data_mod.o mo_sort_mod.o g_level_mod.o tr_newton_mod.o hmat_mod.o cg_descent.o \
       brent_fmin_mod.o lbfgs.o diis_mod.o exponential_extrap_mod.o timer_mod.o alloc_data_mod.o arc_opt_mod.o \
       gcf_egh_mod.o hmat_util_mod.o gcfci.o
GCFLAGS=$(DKEYWORDSLOCAL) $(FFLAGS) -DOSC -DUNIX -DLINUX -DMILSTD1753 -DSFORMAT -DBLAS2 -DBLAS3 -DPIPEMODE -DF95 -DSPINORBIT -DF90 -DLARGEFILES -DCOLIB7 -DNOSTDIN 
GCFLIBS=$(LAP) $(BLAS) 

gcfci.x:$(GCFFOR)
	cd colib/basicio; $(FORTRAN) $(FIXED) $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/humanio; $(FORTRAN)  $(FIXED) $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/linear_algebra; $(FORTRAN)  $(FIXED)  $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/other; $(FORTRAN)  $(FIXED) $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/pack; $(FORTRAN)  $(FIXED)  $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/sifs; $(FORTRAN)  $(FIXED) $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	cd colib/string; $(FORTRAN)  $(FIXED) $(GCFLAGS) *.F ; ar rv ../gcfcolib.a *.o 
	$(FORTRAN) $(GCFLAGS) $?
#	$(LOADER) -o $@ $(GCFOBS)  colib/gcfcolib.a $(GCFLIBS) 
	$(LOADER) -o $@ $(GCFOBS)  $(LIBS) 

gcfdrt.x:gcfdrt1.F90 gcfdrt2.F90
	$(FORTRAN) $(FREE) $(GCFLAGS) $?
#	$(LOADER) -o $@ gcfdrt1.o gcfdrt2.o  ../gcfci/colib/gcfcolib.a $(GCFLIBS)
	$(LOADER) -o $@ gcfdrt1.o gcfdrt2.o  $(LIBS)

