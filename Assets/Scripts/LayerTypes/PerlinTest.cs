using System;
using UnityEngine;
using Random = UnityEngine.Random;

public class PerlinTest : MonoBehaviour
{
    public enum Choice
    {
        MyPerlinNoise1D,
        MyPerlinNoise2D,
        UnityPerlinNoise1D,
        UnityPerlinNoise2D,
        OnlinePerlinNoise1D,
        OnlinePerlinNoise2D
    }

    public Choice choice;

    private int prevSeed = -1;
    public int seed;
    public int[] randomListOfInts = new int[256];

    // Width and height of the texture in pixels.
    public int pixWidth;
    public int pixHeight;

    // The number of cycles of the basic noise pattern that are repeated
    // over the width and height of the texture.
    public float xOffset = 0;
    public float yOffset = 0;
    public float scale = 1;

    public Texture2D noiseTex;
    public Color[] pix;
    public Renderer rend;

    void OnEnable()
    {
        rend = GetComponent<Renderer>();

        // Set up the texture and a Color array to hold pixels during processing.
        noiseTex = new Texture2D(pixWidth, pixHeight);
        pix = new Color[noiseTex.width * noiseTex.height];
        rend.material.mainTexture = noiseTex;
    }

    private float Map(float value, float oldMin, float oldMax, float newMin, float newMax)
    {
        var oldRange = oldMax - oldMin;
        var normalized = (value - oldMin) / oldRange;
        var newRange = newMax - newMin;
        return normalized * newRange + newMin;
    }

    void RunMyPerlinNoise1D()
    {
        if (prevSeed != seed)
        {
            prevSeed = seed;
            Random.InitState(seed);
            for (var i = 0; i < randomListOfInts.Length; i++)
                randomListOfInts[i] = UnityEngine.Random.Range(int.MinValue, int.MaxValue);
        }

        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var x = 0; x < pixWidth; x++)
        {
            var t = x / 100f * scale + xOffset;
            var v = PerlinNoise(t);
            
            // More Octaves
            // var t2 = t * 2;
            // v += PerlinNoise(t2) / 2;
            // var t3 = t2 * 2;
            // v += PerlinNoise(t3) / 4;
            // var t4 = t3 * 2;
            // v += PerlinNoise(t4) / 8;
            
            var y = (int)Map(v, -1, 1, 0, pixHeight - 1);

            if (t - Mathf.Floor(t) < 0.1f)
                pix[x + y * pixWidth] = Color.red;
            else if (GradientVector(randomListOfInts[Mathf.FloorToInt(t) % 256], t - Mathf.Floor(t)) > 0)
                pix[x + y * pixWidth] = Color.green;
            else if (GradientVector(randomListOfInts[Mathf.FloorToInt(t) % 256], t - Mathf.Floor(t)) < 0)
                pix[x + y * pixWidth] = Color.blue;
            else
                pix[x + y * pixWidth] = Color.white;
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    void RunUnityPerlinNoise1D()
    {
        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var x = 0; x < pixWidth; x++)
        {
            var y = (int) Map(Mathf.PerlinNoise(x / 100f * scale + xOffset, 0), 0, 1, 0, pixHeight - 1);
            pix[x + y * pixWidth] = Color.white;
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    void RunOnlinePerlinNoise1D()
    {
        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var x = 0; x < pixWidth; x++)
        {
            var y = (int) Map(Perlin.Noise(x / 100f * scale + xOffset), -1, 1, 0, pixHeight - 1);
            pix[x + y * pixWidth] = Color.white;
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    void RunOnlinePerlinNoise2D()
    {
        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var y = 0; y < pixHeight; y++)
        for (var x = 0; x < pixWidth; x++)
        {
            float v = Map(Perlin.Noise(x / 100f * scale + xOffset, y / 100f * scale + yOffset), -1, 1, 0, 1);
            pix[x + y * pixWidth] = new Color(v, v, v);
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    void RunMyPerlinNoise2D()
    {
        if (prevSeed != seed)
        {
            prevSeed = seed;
            Random.InitState(seed);
            for (var i = 0; i < randomListOfInts.Length; i++)
                randomListOfInts[i] = UnityEngine.Random.Range(int.MinValue, int.MaxValue);
        }

        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var y = 0; y < pixHeight; y++)
        for (var x = 0; x < pixWidth; x++)
        {
            float v = PerlinNoise(x / 100f * scale + xOffset, y / 100f * scale + yOffset);
            pix[x + y * pixWidth] = new Color(v, v, v);
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    void RunUnityPerlinNoise2D()
    {
        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        for (var y = 0; y < pixHeight; y++)
        for (var x = 0; x < pixWidth; x++)
        {
            float v = Mathf.PerlinNoise(x / 100f * scale + xOffset, y / 100f * scale + yOffset);
            pix[x + y * pixWidth] = new Color(v, v, v);
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    private float PerlinNoise(float t)
    {
        var intPart = Mathf.FloorToInt(t);
        t -= intPart;
        var interpolantT = CubicInterpolant(t);
        var randA = randomListOfInts[intPart % 256];
        var randB = randomListOfInts[(intPart + 1) % 256];
        var gradT  = GradientVector(randA, t);
        var inverseGradT = GradientVector(randB, t - 1);
        return Lerp(gradT, inverseGradT, interpolantT);
    }

    private float PerlinNoise(float t, float y)
    {
        var intPartX = Mathf.FloorToInt(t);
        var intPartY = Mathf.FloorToInt(y);
        var floatPartX = t - intPartX;
        var floatPartY = y - intPartY;
        var tX = floatPartX;
        var tY = floatPartY;
        //var tX = Fade(floatPartX);
        //var tY = Fade(floatPartY);
        var randAX = randomListOfInts[intPartX];
        var randBX = randomListOfInts[intPartX+1];
        var randAY = randomListOfInts[intPartY];
        var randBY = randomListOfInts[intPartY+1];
        var lerpX = Mathf.Lerp(randAX, randBX, tX) / 2;
        var lerpY = Mathf.Lerp(randAY, randBY, tY) / 2;
        return Map(lerpX + lerpY, int.MinValue, int.MaxValue, 0, 1);
    }

    private float CubicInterpolant(float t)
    {
        var t3 = t * t * t;
        var t4 = t3 * t;
        var t5 = t4 * t;
        return 6 * t5 - 15 * t4 + 10 * t3;
    }

    private float GradientVector(int randomNumber, float t)
    {
        return (randomNumber & 1) == 0 ? t : -t;
    }

    private float Lerp(float a, float b, float t)
    {
        return a + t * (b - a);
    }

    private float RandomAmplitude(int hash)
    {
        if (hash > int.MaxValue / 2) return 1;
        if (hash < int.MinValue / 2) return -1;
        return Map(hash, int.MinValue / 2, int.MaxValue / 2, -1, 1);
    }
    
    private float GradientVector(int hash, float x, float y)
    {
        return (hash % 2 == 0 ? x : -x) + (hash % 2 == 0 ? y : -y);
    }

    void Update()
    {
        if (choice == Choice.MyPerlinNoise1D) RunMyPerlinNoise1D();
        if (choice == Choice.MyPerlinNoise2D) RunMyPerlinNoise2D();
        if (choice == Choice.UnityPerlinNoise1D) RunUnityPerlinNoise1D();
        if (choice == Choice.UnityPerlinNoise2D) RunUnityPerlinNoise2D();
        if (choice == Choice.OnlinePerlinNoise1D) RunOnlinePerlinNoise1D();
        if (choice == Choice.OnlinePerlinNoise2D) RunOnlinePerlinNoise2D();
    }

    public static class Perlin
    {
        #region Noise functions

        public static float Noise(float x)
        {
            var X = Mathf.FloorToInt(x) & 0xff;
            x -= Mathf.Floor(x);
            var u = Fade(x);
            return Lerp(u, Grad(perm[X], x), Grad(perm[X + 1], x - 1));
        }

        public static float Noise(float x, float y)
        {
            var X = Mathf.FloorToInt(x) & 0xff;
            var Y = Mathf.FloorToInt(y) & 0xff;
            x -= Mathf.Floor(x);
            y -= Mathf.Floor(y);
            var u = Fade(x);
            var v = Fade(y);
            var A = (perm[X] + Y) & 0xff;
            var B = (perm[X + 1] + Y) & 0xff;
            return Lerp(v, Lerp(u, Grad(perm[A], x, y), Grad(perm[B], x - 1, y)),
                Lerp(u, Grad(perm[A + 1], x, y - 1), Grad(perm[B + 1], x - 1, y - 1)));
        }

        public static float Noise(Vector2 coord)
        {
            return Noise(coord.x, coord.y);
        }

        public static float Noise(float x, float y, float z)
        {
            var X = Mathf.FloorToInt(x) & 0xff;
            var Y = Mathf.FloorToInt(y) & 0xff;
            var Z = Mathf.FloorToInt(z) & 0xff;
            x -= Mathf.Floor(x);
            y -= Mathf.Floor(y);
            z -= Mathf.Floor(z);
            var u = Fade(x);
            var v = Fade(y);
            var w = Fade(z);
            var A = (perm[X] + Y) & 0xff;
            var B = (perm[X + 1] + Y) & 0xff;
            var AA = (perm[A] + Z) & 0xff;
            var BA = (perm[B] + Z) & 0xff;
            var AB = (perm[A + 1] + Z) & 0xff;
            var BB = (perm[B + 1] + Z) & 0xff;
            return Lerp(w, Lerp(v, Lerp(u, Grad(perm[AA], x, y, z), Grad(perm[BA], x - 1, y, z)),
                    Lerp(u, Grad(perm[AB], x, y - 1, z), Grad(perm[BB], x - 1, y - 1, z))),
                Lerp(v, Lerp(u, Grad(perm[AA + 1], x, y, z - 1), Grad(perm[BA + 1], x - 1, y, z - 1)),
                    Lerp(u, Grad(perm[AB + 1], x, y - 1, z - 1), Grad(perm[BB + 1], x - 1, y - 1, z - 1))));
        }

        public static float Noise(Vector3 coord)
        {
            return Noise(coord.x, coord.y, coord.z);
        }

        #endregion

        #region fBm functions

        public static float Fbm(float x, int octave)
        {
            var f = 0.0f;
            var w = 0.5f;
            for (var i = 0; i < octave; i++)
            {
                f += w * Noise(x);
                x *= 2.0f;
                w *= 0.5f;
            }

            return f;
        }

        public static float Fbm(Vector2 coord, int octave)
        {
            var f = 0.0f;
            var w = 0.5f;
            for (var i = 0; i < octave; i++)
            {
                f += w * Noise(coord);
                coord *= 2.0f;
                w *= 0.5f;
            }

            return f;
        }

        public static float Fbm(float x, float y, int octave)
        {
            return Fbm(new Vector2(x, y), octave);
        }

        public static float Fbm(Vector3 coord, int octave)
        {
            var f = 0.0f;
            var w = 0.5f;
            for (var i = 0; i < octave; i++)
            {
                f += w * Noise(coord);
                coord *= 2.0f;
                w *= 0.5f;
            }

            return f;
        }

        public static float Fbm(float x, float y, float z, int octave)
        {
            return Fbm(new Vector3(x, y, z), octave);
        }

        #endregion

        #region Private functions

        static float Fade(float t)
        {
            return t * t * t * (t * (t * 6 - 15) + 10);
        }

        static float Lerp(float t, float a, float b)
        {
            return a + t * (b - a);
        }

        static float Grad(int hash, float x)
        {
            return (hash & 1) == 0 ? x : -x;
        }

        static float Grad(int hash, float x, float y)
        {
            return ((hash & 1) == 0 ? x : -x) + ((hash & 2) == 0 ? y : -y);
        }

        static float Grad(int hash, float x, float y, float z)
        {
            var h = hash & 15;
            var u = h < 8 ? x : y;
            var v = h < 4 ? y : (h == 12 || h == 14 ? x : z);
            return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
        }

        public static int[] perm =
        {
            151, 160, 137, 91, 90, 15,
            131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
            190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
            88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
            77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
            102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
            135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
            5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
            223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
            251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
            49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
            138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180,
            151
        };

        #endregion
    }
}