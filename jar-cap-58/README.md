# Ø58 mm twist-off jar cap

For glass jars with a 58 mm lug (twist-off) mouth. The model is parametric: edit it in OpenSCAD.

| File | Use |
|---|---|
| `jar_cap_58.stl` | The cap. Print it top-down with no supports. PETG works well, PLA is fine too. 0.2 mm layers, 3 or more walls. |
| `jar_cap_58_gasket_tpu.stl` | An optional seal ring (Ø58.3 × Ø48 × 1.5 mm). Print it in TPU, or cut one from 1–2 mm foam or silicone sheet. |
| `jar_cap_58.scad` | The source, for adjusting the fit. |

## Adjusting the fit
1. Measure the outside diameter across the glass threads and set `glass_d`. If you can, start by printing a cap with `skirt_h=4` and no lugs to check the fit quickly.
2. If the cap is too loose or tight on the threads, change `clearance` (default 0.6).
3. If it doesn't grip, raise `lug_depth`. If it won't go past the threads, lower it.
4. If the cap stops before it seals, lower `lug_z`. If it rattles when closed, raise it.
5. The default is 4 lugs. Set `lugs` to match the number of thread starts on the glass (count them).
