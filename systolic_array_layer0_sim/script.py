import torch
import torch.nn as nn
import numpy as np

ic = 3
ih = 416
iw = 416

oc = 16
oh = 414
ow = 414

kk = 3

conv2d = nn.Conv2d(in_channels=ic, out_channels=oc, kernel_size=kk, padding=0, bias=False)

ifm = torch.rand(1, ic, ih, iw) * 15 - 5
ifm = torch.round(ifm)

weight = torch.rand(oc, ic, kk, kk) * 15 - 6
weight = torch.round(weight)

conv2d.weight = nn.Parameter(weight)

ofm = conv2d(ifm)

ifm_np = ifm.data.numpy().astype(int)
weight_np = weight.data.numpy().astype(int)
ofm_np = ofm.data.numpy().astype(int)

with open("ifm_bin_c%dxh%dxw%d.txt" % (ic, ih, iw), "w") as f:
    for i in range(ic):
        for j in range(ih):
            for k in range(iw):
                f.write(np.binary_repr(ifm_np[0, i, j, k], 8) + "\n")

with open("ofm_bin_c%dxh%dxw%d.txt" % (oc, oh, ow), "w") as f:
    for i in range(oc):
        for j in range(oh):
            f.write(" ".join(np.binary_repr(ofm_np[0, i, j, k], 16) for k in range(ow)) + "\n")

with open("weight_bin_co%dxci%dxk%dxk%d.txt" % (oc, ic, kk, kk), "w") as f:
    for j in range(ic):
        for k in range(kk):
            for l in range(kk):
                for i in range(oc):
                    f.write(np.binary_repr(weight_np[i, j, k, l], 8) + "\n")

with open("ifm_dec_c%dxh%dxw%d.txt" % (ic, ih, iw), "w") as f:
    for i in range(ic):
        for j in range(ih):
            for k in ifm_np[0, i, j, :]:
                f.write(str(k) + " \t")
            f.write("\n")
        f.write("\n")

with open("ofm_dec_c%dxh%dxw%d.txt" % (oc, oh, ow), "w") as f:
    for i in range(oc):
        for j in range(oh):
            for k in ofm_np[0, i, j, :]:
                f.write(str(k) + " ")
            f.write("\n")
        f.write("\n")

with open("weight_dec_co%dxci%dxk%dxk%d.txt" % (oc, ic, kk, kk), "w") as f:
    for i in range(oc):
        for j in range(ic):
            for k in range(kk):
                for l in weight_np[i, j, k, :]:
                    f.write(str(l) + " ")
                f.write("\n")
            f.write("\n")
        f.write("\n")

