using UnityEngine;

public class Data : MonoBehaviour
{
    public static Data singleton;
    
    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
    public static void LoadMain()
    {
        GameObject gameObject = GameObject.Instantiate(Resources.Load("Data")) as GameObject;
        singleton = gameObject.GetComponent<Data>();
        gameObject.name = "Data";
        gameObject.SetActive(false);
        DontDestroyOnLoad(gameObject);
    }
}
