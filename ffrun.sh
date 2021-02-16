TASK=$1
INP=$1.inp
OUT=$1.out
DAT=$1.dat
NCPU=$2
if [[ x$NCPU == x ]]; then NCPU=24; fi
echo "Firefly will run using $NCPU CPUs"
MPIRUN=mpirun
FFHOME=/apps/firefly820
FFBIN=$FFHOME/firefly820
BASIS="BASIS.LIB"
WORKDIR=`pwd`
JOBDIR=/scratch/ff/$TASK
TMPDIR="$JOBDIR/Firefly"
if [ -d $JOBDIR ]; then rm -rv $JOBDIR; fi 
mkdir -pv $JOBDIR
cp -v $INP $JOBDIR/
if [ -f "$WORKDIR/$BASIS" ]; then 
    cp -v "$WORKDIR/$BASIS" "$JOBDIR"
fi 
cd $JOBDIR
$MPIRUN -n $NCPU $FFBIN -stdext -ex $FFHOME -r -f -t $TMPDIR -i $INP -o $OUT  
cp "$TMPDIR.0/$DAT" "$WORKDIR/$DAT" 
cp "$TMPDIR.0/$DAT" "$JOBDIR/$DAT" 
rm -r "$TMPDIR".*
cp -v $JOBDIR/$OUT $WORKDIR/
