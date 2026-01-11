/**
 * Bao, a Lightweight Static Partitioning Hypervisor
 *
 * Copyright (c) Bao Project (www.bao-project.org), 2019-
 *
 * Authors:
 *      Jose Martins <jose.martins@bao-project.org>
 *
 * Bao is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License version 2 as published by the Free
 * Software Foundation, with a special exception exempting guest code from such
 * license. See the COPYING file in the top-level directory for details.
 *
 */

#ifndef __FENCES_ARCH_H__
#define __FENCES_ARCH_H__

static inline void syncp(void)
{
    __asm__ volatile("syncp" ::: "memory");
}

static inline void syncm(void)
{
    __asm__ volatile("syncm" ::: "memory");
}

static inline void synci(void)
{
    __asm__ volatile("synci" ::: "memory");
}

static inline void synce(void)
{
    __asm__ volatile("synce" ::: "memory");
}

static inline void fence_ord_write(void)
{
    synci();
}

static inline void fence_ord_read(void)
{
    synci();
}

static inline void fence_ord(void)
{
    synci();
}

static inline void fence_sync_write(void)
{
    synci();
}

static inline void fence_sync_read(void)
{
    synci();
}

static inline void fence_sync(void)
{
    synci();
}

#endif /* __FENCES_ARCH_H__ */