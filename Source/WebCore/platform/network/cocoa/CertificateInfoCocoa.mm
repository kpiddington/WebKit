/*
 * Copyright (C) 2010-203 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "config.h"
#import "CertificateInfo.h"

namespace WebCore {

#ifndef NDEBUG
void CertificateInfo::dump() const
{
    if (m_trust) {

#if HAVE(SEC_TRUST_COPY_CERTIFICATE_CHAIN)
        auto chain = adoptCF(SecTrustCopyCertificateChain(trust().get()));
        CFIndex entries = CFArrayGetCount(chain.get());
#else
        CFIndex entries = SecTrustGetCertificateCount(trust().get());
#endif
        NSLog(@"CertificateInfo SecTrust\n");
        NSLog(@"  Entries: %ld\n", entries);
        for (CFIndex i = 0; i < entries; ++i) {
#if HAVE(SEC_TRUST_COPY_CERTIFICATE_CHAIN)
            RetainPtr<CFStringRef> summary = adoptCF(SecCertificateCopySubjectSummary(checked_cf_cast<SecCertificateRef>(CFArrayGetValueAtIndex(chain.get(), i))));
#else
            RetainPtr<CFStringRef> summary = adoptCF(SecCertificateCopySubjectSummary(SecTrustGetCertificateAtIndex(trust().get(), i)));
#endif
            NSLog(@"  %@", (__bridge NSString *)summary.get());
        }
        return;
    }
    NSLog(@"CertificateInfo (Empty)\n");
}
#endif

} // namespace WebCore
