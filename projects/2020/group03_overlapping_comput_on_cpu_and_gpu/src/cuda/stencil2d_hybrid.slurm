#!/bin/bash -l
#SBATCH --job-name="stencil2d_hybrid"
#SBATCH --time=00:20:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-core=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --partition=normal
#SBATCH --constraint=gpu
#SBATCH --hint=nomultithread

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

nx=128
ny=128
nz=64
niters=1024
z_slices_on_cpu=1

#for nxy in 256 512 1024
#do
#    srun ./stencil2d_gpu.x --nx $nxy --ny $nxy --nz $nz --niters $niters
#    for z_slices_on_cpu in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
#    do
#        srun ./stencil2d_hybrid.x --nx $nxy --ny $nxy --nz $nz --niters $niters --z_slices_on_cpu $z_slices_on_cpu
#    done
#done

for nxy in 1024
do
    for z_slices_on_cpu in 1 2 3 4 5 6 7 8 9 10
    do
        z_slices_on_gpu=$(($nz-$z_slices_on_cpu))
        echo $z_slices_on_cpu $z_slices_on_gpu
        srun ./stencil2d_cpu.x --nx $nxy --ny $nxy --nz $nz --niters $niters --z_slices_on_cpu $z_slices_on_cpu
        srun ./stencil2d_gpu.x --nx $nxy --ny $nxy --nz $z_slices_on_gpu --niters $niters
    done
done

#srun               ./stencil2d_hybrid.x --nx $nx --ny $ny --nz $nz --niters $niters --z_slices_on_cpu $z_slices_on_cpu
#srun nvprof        ./stencil2d_hybrid.x --nx $nx --ny $ny --nz $nz --niters $niters --z_slices_on_cpu $z_slices_on_cpu
#srun cuda-memcheck ./stencil2d_hybrid.x --nx $nx --ny $ny --nz $nz --niters $niters --z_slices_on_cpu $z_slices_on_cpu

