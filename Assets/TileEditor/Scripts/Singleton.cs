using UnityEngine;

namespace TileEditor
{
    public class Singleton<T> : MonoBehaviour where T : Singleton<T>
    {
        public static T instance;

        protected virtual void Awake()
        {
            if (instance)
                Destroy(this);
            else
                instance = (T) this;
        }

        protected void OnDestroy()
        {
            if (instance == this)
                instance = null;
        }
    }
}