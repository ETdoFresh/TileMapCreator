using UnityEngine;

public class PerlinTest : MonoBehaviour
{
    public int seed;
    public int[] randomListOfInts = new int[256];

    // Width and height of the texture in pixels.
    public int pixWidth;
    public int pixHeight;

    // The number of cycles of the basic noise pattern that are repeated
    // over the width and height of the texture.
    public float offset = 0;
    public float scale = 1;

    public Texture2D noiseTex;
    public Color[] pix;
    public Renderer rend;

    void OnEnable()
    {
        Random.InitState(seed);
        for (var i = 0; i < randomListOfInts.Length; i++)
            randomListOfInts[i] = UnityEngine.Random.Range(int.MinValue, int.MaxValue);

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

    void CalcNoise()
    {
        for (var i = 0; i < pix.Length; i++)
            pix[i] = Color.black;

        var midPointY = pixHeight / 2;
        for (var x = 0; x < pixWidth; x++)
        {
            var y = (int) Map(PerlinNoise(x / 100f * scale + offset), 0, 1, 0, 200);
            pix[x + y * pixWidth] = Color.white;
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    private float PerlinNoise(float x)
    {
        var intPart = Mathf.FloorToInt(x);
        var floatPart = x - intPart;
        var inverse = floatPart - 1;
        var t = Fade(floatPart);
        var num1 = GradientVector(randomListOfInts[intPart], floatPart);
        var num2 = GradientVector(randomListOfInts[intPart + 1], inverse);
        var value = Mathf.Lerp(num1, num2, t);
        return Map(value, -1, 1, 0, 1);
    }

    private float Fade(float t)
    {
        var t3 = t * t * t;
        var t4 = t3 * t;
        var t5 = t4 * t;
        return 6 * t5 - 15 * t4 + 10 * t3;
    }

    private float GradientVector(int hashCode, float t)
    {
        return hashCode % 2 == 0 ? t : -t;
    }

    void Update()
    {
        CalcNoise();
    }
}